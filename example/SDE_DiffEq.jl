using MultilevelEstimators
using DifferentialEquations
using Reporter

# DifferentialEquations SDE example taken from https://diffeq.sciml.ai/stable/tutorials/sde_example/

α=1
β=1
u₀=1/2
f(u,p,t) = α*u
g(u,p,t) = β*u
dt = 1//2^(4)
tspan = (0.0,1.0)
prob = SDEProblem(f,g,u₀,(0.0,1.0), dt=dt)

sol = solve(prob,EM())
using Plots; plotly() # Using the Plotly backend
p1 = plot(sol)

# MultilevelEstimators.jl setup 

SDE_probs = Vector{typeof(prob)}(undef,7)
for i in 1:7
    dt = 1//2^(i+1)
    SDE_probs[i] = SDEProblem(f,g,u₀,(0.0,1.0), dt=dt)
end

function sample_SDE(level, ω) 
    # solve on finest grid
    sol1 = solve(SDE_probs[level + one(level)], EM()) # TO DO, dt needs to be varied
    Qf = sol1.u[end]

    # compute difference when not on coarsest grid
    dQ = Qf
    if level != Level(0)
        sol2 = solve(SDE_probs[level], EM(), noise=NoiseWrapper(sol1.W))
        Qc = sol2.u[end]
        dQ -= Qc
    end

    dQ, Qf 
end

distributions = [Normal()]

estimator = Estimator(ML(), MC(), sample_SDE, distributions, folder=DIR)

# run Estimator
h = run(estimator, 5e-2)

full_history = History(h)

history=load(DIR,"history")
report(history, filepath, include_preamble=true)