using JuMP, GLPK

if !((@isdefined t) * (@isdefined t) * (@isdefined t))
    throw("Load dataset 'q4-data.jl' before running this script")
end

n = size(t,1)
#T = t

model = Model(GLPK.Optimizer)

M = 600

@variable(model, x[1:n,1:n], Bin)
@variable(model, u[1:n] .>= 0)
@variable(model, tt[1:n] .>=0)
@variable(model, w[1:n] .>=0)

ui = repeat(u[2:end],1,n-1)
uj = transpose(ui)

ti = repeat(tt[2:end],1,n-1)
tj = transpose(ti)

wi = repeat(w[2:end],1,n-1)
wj = transpose(wi)

@objective(model, Min, sum(x.*t) + sum(w))

@constraint(model, sum(x,dims=1)  .== 1 ) #We must visit each customer once
@constraint(model, sum(x,dims=2)  .== 1 ) #We must leave each customer once

@constraint(model, u[1] == 1) #We must start at home (1)
@constraint(model, ui .- uj .+ 1 .<= (n-1).*(1 .- x[2:end,2:end]))
@constraint(model, u[2:end] .>= 2)
@constraint(model, u[2:end] .<= n)

@constraint(model, tt[1] .== 0)
@constraint(model, tt[2:end] .>= sum(x[1,:].*t[1,:]) + w[1])
@constraint(model, tt[2:end] .<= sum(x.*t) .- sum(x[:,1].*t[:,1]) .+ sum(w))
@constraint(model, ti .- tj .+ x[2:end,2:end].*t[2:end,2:end] .+ wj .<= M.*(1 .- x[2:end,2:end]))

@constraint(model, tt[2:end] .<= l[1:end])
@constraint(model, tt[2:end] .>= e[1:end])
#@constraint(model, w .<= M)



optimize!(model)


if termination_status(model) == MOI.OPTIMAL
    println("\nObjective value: ", objective_value(model))
    
    I = Array(1:n)
    Idx = copy(I)
    U = (round.(value.(u)))
    TT = (round.(value.(tt)))
    W = round.(value.(w))

    #Interpret result:
    for j in 2:n
        I[j] = Idx[j .== U][1]
        println("Wait ", W[I[j-1]] ," then go from ", I[j - 1] - 1, " to ", I[j] - 1, " with cost ", t[I[j-1],I[j]], " for a travel time of ", TT[I[j]])
    end
    println("Wait ", W[I[end]] ," then go from ", I[end] - 1, " to ", I[1]-1, " with cost ", t[I[end],I[1]], " for a travel time of ", TT[I[end]] + t[I[end],I[1]])

    if  size(unique(I),1) != n #Check if solution contains loops smaller than n
        println("This solution is not feasable!!")
    end

    #println("a = ", value.(a))
    #println("xe below30 = ", JuMP.value.(xeBelow))
    #println("xe above30 = ", JuMP.value.(xeAbove))
else
    println("Optimize was not succesful. Return code: ", termination_status(model))
end

#println("Go from ", i ," to ",  Index[value.(x)[:,i]] .== 1)