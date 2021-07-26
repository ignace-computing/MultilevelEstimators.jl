using Distributed
using DifferentialEquations
using Plots

addprocs()
@everywhere using DifferentialEquations

function f(du,u,p,t)
  du[1] = p[1] * u[1] - p[2] * u[1]*u[2]
  du[2] = -3 * u[2] + u[1]*u[2]
end

function g(du,u,p,t)
    du[1] = p[3]*u[1]
    du[2] = p[4]*u[2]
  end

  p = [1.5,1.0,0.1,0.1]
prob = SDEProblem(f,g,[1.0,1.0],(0.0,10.0),p)

function prob_func(prob,i,repeat)
    x = 0.3rand(2)
    # remake(prob,p=[p[1:2];x])
    remake(prob)
  end

  ensemble_prob = EnsembleProblem(prob,prob_func=prob_func)
sim = solve(ensemble_prob,SRIW1(),trajectories=10)
using Plots; plotly()
using Plots; plot(sim,linealpha=0.6,color=:blue,vars=(0,1),title="Phase Space Plot")
plot!(sim,linealpha=0.6,color=:red,vars=(0,2),title="Phase Space Plot")

summ = EnsembleSummary(sim,0:0.1:10)
pyplot() # Note that plotly does not support ribbon plots
plot(summ,fillalpha=0.5)