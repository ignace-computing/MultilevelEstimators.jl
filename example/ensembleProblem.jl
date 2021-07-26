function prob_func(prob,i,repeat)
    x = 0.3rand(2)
    # remake(prob,p=[p[1:2];x])
    remake(prob)
end

ensemble_prob = EnsembleProblem(prob,prob_func=prob_func)
sim = solve(ensemble_prob,SRIW1(),trajectories=10^2)
summ = EnsembleSummary(sim,0:0.1:10)