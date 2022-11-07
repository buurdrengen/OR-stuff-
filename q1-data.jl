
staff_demand=[15 15 18 37 43 47 58 54 43 29 24 19]

# Lecture 7, Example 3
# 1-index

# 3) Construct constraints linearly
# M ?
## Subsection 1 & 2
using JuMP
using GLPK
m  = Model(GLPK.Optimizer)

@variable(m, x[1:12],Int)

@objective(m,Min, x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7] + x[8] + x[9] + x[10] + x[11] + x[12] )
@constraint(m, x[1] + x[9] + x[10] + x[12] >= 15)
@constraint(m, x[1] + x[2] + x[10] + x[11] >= 15)
@constraint(m, x[2] + x[3] + x[11] + x[12] >= 18)
@constraint(m, x[1] + x[3] + x[4] + x[12] >= 37)
@constraint(m, x[1] + x[2] + x[4] + x[5] >= 43)
@constraint(m, x[2] + x[3] + x[5] + x[6] >= 47)
@constraint(m, x[3] + x[4] + x[6] + x[7] >= 58)
@constraint(m, x[4] + x[5] + x[7] + x[8] >= 54)
@constraint(m, x[5] + x[6] + x[8] + x[9] >= 43)
@constraint(m, x[6] + x[7] + x[9] + x[10] >= 29)
@constraint(m, x[7] + x[8] + x[10] + x[11] >= 24)
@constraint(m, x[8] + x[9] + x[11] + x[12] >= 19)

optimize!(m)
println("Objective value:", objective_value(m))
println("Variable values:", value.(x))

## Subsection 3 & 4
# Not more than 5 starting blocks
using JuMP
using GLPK
m  = Model(GLPK.Optimizer)

@variable(m, x[1:12].>=0,Int)
@variable(m, y[1:12], Bin)

M = 58

@objective(m,Min, x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7] + x[8] + x[9] + x[10] + x[11] + x[12] )
@constraint(m, x[1] + x[9] + x[10] + x[12] >= 15)
@constraint(m, x[1] + x[2] + x[10] + x[11] >= 15)
@constraint(m, x[2] + x[3] + x[11] + x[12] >= 18)
@constraint(m, x[1] + x[3] + x[4] + x[12] >= 37)
@constraint(m, x[1] + x[2] + x[4] + x[5] >= 43)
@constraint(m, x[2] + x[3] + x[5] + x[6] >= 47)
@constraint(m, x[3] + x[4] + x[6] + x[7] >= 58)
@constraint(m, x[4] + x[5] + x[7] + x[8] >= 54)
@constraint(m, x[5] + x[6] + x[8] + x[9] >= 43)
@constraint(m, x[6] + x[7] + x[9] + x[10] >= 29)
@constraint(m, x[7] + x[8] + x[10] + x[11] >= 24)
@constraint(m, x[8] + x[9] + x[11] + x[12] >= 19)
@constraint(m, sum(y) <= 5)
@constraint(m, x .<= y*M)

optimize!(m)
println("Objective value:", objective_value(m))
println("Variable values:", value.(x))
