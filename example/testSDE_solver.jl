a,b = sample_SDE(1,1)

p1 = plot()
plot!(p1, a, label="difference")
plot!(p1, b, label="fine solution")