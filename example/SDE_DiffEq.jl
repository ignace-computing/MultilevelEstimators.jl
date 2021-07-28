using MultilevelEstimators
using DifferentialEquations
using Reporter
using FileIO
using DelimitedFiles

DIR=pwd()*"/MultilevelEstimators/data"

# DifferentialEquations SDE example partly taken from https://diffeq.sciml.ai/stable/tutorials/sde_example/

# define the problem
α=0.05
β=0.2
u₀=100.
f(u,p,t) = α*u
g(u,p,t) = β*u
dt = 1//2^(4)
T = 1.
tspan = (0.0, T)
P_func = (x) -> exp(-α*T)*maximum([0, x-100.])
prob = SDEProblem(f,g,u₀,(0.0,1.0), dt=dt)

sol = solve(prob,EM())
using Plots; plotly() # Using the Plotly backend
p1 = plot(sol)

MEAN = 0
P = 10^4
for p=1:P
    sol = solve(prob,EM())
    MEAN += sol[end]
end
MEAN /= P

# The mean of the solution at the end, should equal ???

# Multilevelusing FileIOEstimators.jl setup, adapted from documentation

LL = 20
SDE_probs = Vector{typeof(prob)}(undef,LL)
for i in 1:LL
    dt = 1//10*1//2^(i+1)
    SDE_probs[i] = SDEProblem(f, g, u₀, (0.0, 1.0), dt=dt)
end

function sample_SDE(level, ω) 
    # solve on finest grid
    sol1 = solve(SDE_probs[level + one(level)], EM()) # TO DO, dt needs to be varied
    Qf = P_func(sol1.u[end])

    # compute difference when not on coarsest grid
    dQ = Qf
    if level != Level(0)
        sol2 = solve(SDE_probs[level], EM(), noise=NoiseWrapper(sol1.W))
        Qc = P_func(sol2.u[end])
        dQ -= Qc
    end

    dQ, Qf 
end

distributions = [Normal()]
estimator = Estimator(ML(), MC(), sample_SDE, distributions, folder=DIR)

# run Estimator
h = run(estimator, 5e-1)

S = MultilevelEstimators.samples_diff(estimator)
name = estimator[:name]
sf_dir= string(name[1:end-5])

isdir(joinpath(DIR,sf_dir)) || mkdir(joinpath(DIR,sf_dir))
isdir(joinpath(DIR,sf_dir,"Samples")) || mkdir(joinpath(DIR,sf_dir,"Samples"))

for idx in CartesianIndices(S)
    idx_dir = joinpath(DIR,sf_dir,"Samples", join(idx.I,"_"))
    isdir(idx_dir) || mkdir(idx_dir)
    for k in keys(S[idx])
        writedlm(joinpath(idx_dir,string("samples_level_",k[1]-1,".txt")),S[idx][k])
    end
end

full_history = History(h)

filePath = DIR*"/UntitledEstimator.jld2"
history = load(filePath,"history")
report(history, folder=DIR*"/testReport", include_preamble=true)

