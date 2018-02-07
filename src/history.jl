## history.jl : store general info about an estimator

struct History
    iter::Int64
    data::Vector{Dict{Symbol, Any}}
end

History() = History(0,Dict{Symbol,Any}[])

#=
"""
    getindex(sh, s)

Get collection or tolerance associated with key `s` in `sh::SimulatorHistory`.

    getindex(sh, s, kwargs...)

Access elements of the collection associated with key `s` in `sh::SimulatorHistory`.
"""
getindex(sh::SimulatorHistory, s::Symbol) = sh.data[s]
getindex(sh::SimulatorHistory, s::Symbol, kwargs...) = sh.data[s][kwargs...]

"""
    setindex!(sh, tol, s)

Set tolerance value associated with `s` in `sh::SimulatorHistory` to `tol`.

    setindex!(sh, val, s, kwargs...)
    
Set collection element associated with key `s` in `sh::SimulatorHistory` to val.
"""
setindex!(sh::SimulatorHistory, val, s::Symbol) = sh.data[s] = val
setindex!(sh::SimulatorHistory, val, s::Symbol, kwargs...) = sh.data[s][kwargs...] = val

"""
    push!(sh, key, data)

Push contents of `data` to collection associated with `key` in `sh::SimulatorHistory`.
"""
push!(sh::SimulatorHistory, key::Symbol, data) = sh.data[key] = data

"""
    nextiter!(ml)

Adds one to the number of iterations in [`SimulatorHistory`](@ref) `sh`. This is
necessary to avoid overwriting information with `push!(ml)`.
"""
nextiter!(sh::SimulatorHistory) = sh.iters+=1

"""
    keys(sh)

Key iterator for data in `SimulatorHistory` `sh`.
"""
keys(sh::SimulatorHistory) = keys(sh.data)
=#
