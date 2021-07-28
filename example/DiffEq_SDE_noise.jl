# taken from https://diffeq.sciml.ai/stable/features/noise_process/

using StochasticDiffEq,  DiffEqNoiseProcess
using Test

f1(u, p, t) = 1.01u
g1(u, p, t) = 1.01u
dt = 1//2^(4)
prob1 = SDEProblem(f1,g1,1.0,(0.0,1.0))
sol1 = solve(prob1,EM(),dt=dt,save_noise = true)

W2 = NoiseWrapper(sol1.W)
prob1 = SDEProblem(f1,g1,1.0,(0.0,1.0),noise=W2)
sol2 = solve(prob1,EM(),dt=dt)

@test sol1.u ≈ sol2.u

W3 = NoiseWrapper(sol1.W)
prob2 = SDEProblem(f1,g1,1.0,(0.0,1.0),noise=W3)

# smaller timestep
dt = 1//2^(5)
sol3 = solve(prob2,EM(),dt=dt)

using Plots
plot(sol1)
plot!(sol2)
plot!(sol3)