LL = 20
SDE_probs = zeros(LL)
for i in 1:LL
    dt = 1//2^(i+1)
    SDE_probs[i] = dt
end

function sample_SDE_path(level, ω; TEST=false) 
    # solve on finest grid
    SDE_prob_coarse = SDEProblem(f, g, u₀, (0.0, 1.0), dt=SDE_probs[level + one(level)])
    sol1 = solve(SDE_prob_coarse, EM(), save_noise = true) # TO DO, dt needs to be varied
    Qf = sol1.u[1:2:end]

    # compute difference when not on coarsest grid
    dQ = copy(Qf)
    if level != Level(0)
        SDE_prob_fine = SDEProblem(f, g, u₀, (0.0, 1.0), dt=SDE_probs[level])
        sol2 = solve(SDE_prob_fine, EM())
        Qc = sol2.u
        dQ -= Qc
    end

    if TEST
        return dQ, Qf, Qc
    else
        return dQ, Qf
    end 
end

# define the problem
a, b, c = sample_SDE_path(7, 1., TEST=true)

println("succes")

p2 = plot()
plot!(p2, b, label="fine")
plot!(p2, c, label="coarse")