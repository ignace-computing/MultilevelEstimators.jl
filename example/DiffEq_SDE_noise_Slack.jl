using StochasticDiffEq,  DiffEqNoiseProcess, Test

f1(u, p, t) = 1.01u
g1(u, p, t) = 1.01u
dt = 1//2^(4)
prob1 = SDEProblem(f1,g1,1.0,(0.0,1.0))
sol1 = solve(prob1,EM(),dt=dt,save_noise = true)

W2 = NoiseWrapper(sol1.W)
prob2 = SDEProblem(f1,g1,1.0,(0.0,1.0),noise=W2)
dt = 1//2^(5)
sol2 = solve(prob2,EM(),dt=dt)

W3 = NoiseWrapper(sol1.W)
prob3 = SDEProblem(f1,g1,1.0,(0.0,1.0))
dt = 1//2^(5)
sol3 = solve(prob3,EM(),dt=dt,noise=W3)

using Plots
plotly()
plot(sol1, label="reference")
plot!(sol2, label="good coarse reconstruction")
plot!(sol3, label="bad coarse reconstruction")