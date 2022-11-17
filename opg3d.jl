using JuMP, GLPK
if !(@isdefined t)
    throw("Load dataset 'q3-data.jl' before running this script")
end

n = size(t,1)
T = t

model = Model(GLPK.Optimizer)

@variable(model, x[1:n,1:n], Bin)
@variable(model, u[1:n])

ui = repeat(u[2:end],1,n-1)
uj = transpose(ui)

@objective(model, Min, sum(x.*t))

@constraint(model, sum(x,dims=1)  .== 1 ) #We must visit each customer once
@constraint(model, sum(x,dims=2)  .== 1 ) #We must leave each customer once

@constraint(model, u[1] == 1) #We must start at home (1)
@constraint(model, ui .- uj .+ 1 .<= (n-1).*(1 .- x[2:end,2:end])) # i->j => uj = ui + 1
@constraint(model, u[2:end] .>= 2)
@constraint(model, u[2:end] .<= n)


optimize!(model) # Notice the distinct lack of loops in the constraints...


if termination_status(model) == MOI.OPTIMAL
    println("\nObjective value: ", objective_value(model))
    
    I = Array(1:n)
    Idx = copy(I)
    U = Int.(round.(value.(u)))

    #Interpret result:
    for j in 2:n
        I[j] = Idx[j .== U][1]
        println("Go from ", I[j - 1] - 1, " to ", I[j] - 1)
    end
    println("Go from ", I[end] - 1, " to ", I[1]-1)

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