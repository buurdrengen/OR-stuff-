using JuMP, GLPK
t=[0 43	37 36 40 31 34 35 16 9 25;
   53 0	17 17 15 22 21 20 38 57 40;
   47 16 0 12 15 16 17 17 33 52	35;
   46 17 12 0 15 15 15 15 31 50	35;
   50 15 15 15 0 20 17 16 35 54	40;
   41 22 16 15 20 0 16 18 26 45	31;
   44 21 17 15 17 16 0 12 28 47	37;
   45 20 17 15 16 18 12	0 30 48	39;
   26 38 33 31 35 26 28	30 0 29	32;
   19 57 52 50 54 45 47 48 29 0	44;
   35 40 35 35 40 31 37	39 32 44 0
]
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
@constraint(model, ui .- uj .+ 1 .<= (n-1).*(1 .- x[2:end,2:end]))
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