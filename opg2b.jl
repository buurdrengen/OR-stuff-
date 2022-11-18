using JuMP
using GLPK

struct Lecture
    start::Int32
    finish::Int32
end

lectures = [Lecture(570,600), Lecture(510,555), Lecture(630,675), Lecture(720,765), Lecture(780,825), Lecture(480,540), Lecture(540,600), Lecture(600,660), 
            Lecture(660,720), Lecture(870,930), Lecture(960,1020), Lecture(480,600), Lecture(660,780), Lecture(720,840), Lecture(840,960)]    

n = length(lectures)
m = Model(GLPK.Optimizer)

@variable(m, x[lectures], Bin)
@objective(m, Max, sum(x[a] for a in lectures))

for i=1:n-1
	for j=i+1:n
		ai = lectures[i]
		aj = lectures[j]
		if(!(ai.finish <= aj.start || aj.finish <= ai.start))
			@constraint(m, x[ai]+x[aj]<=1)
		end
	end
end

optimize!(m)
println("Objective Value: ", objective_value(m))
println("Variable values: ", JuMP.value.(x))

>>
1.0
 0.0
 0.0
 1.0
 1.0
 1.0
 0.0
 1.0
 1.0
 1.0
 1.0
 0.0
 0.0
 0.0
 0.0
Objective Value: 8.0
