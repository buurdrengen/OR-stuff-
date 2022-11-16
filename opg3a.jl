
function minn(list)
    N = 1:length(list)
    qvl = list .!= 0
    N = N[qvl]
    list = list[qvl]
    mini = minimum(list)
    idx = minimum(N[list .== mini])
    return mini, idx
end


function CheckCost(table,path)
    n = 1:size(table,1)
    cost = 0
    for j in n[1:end-1]
        #print("Checking index ",j, "\n")
        cost = cost + table[path[j],path[j+1]]
    end
    return cost + table[path[end],path[1]]
end


T = t

n = 1:length(T[:,1])

i = 1
I = Array(n)
I[1] = i
Index = Array(n)
local cost = 0

println("Test")
for j in n[1:end-1]
    liste = T[i,:]
    #print("i: ", i, "\n")
    #print(liste)
    mini, idx = minn(liste)
    cost = cost + mini
    println(j, ": Going from customer ", I[j], " to ", Index[idx], " with cost ", mini)

    T = T[1:end .!= i , 1:end .!= i] #Remove index i from table T
    I[j+1] = Index[idx]
    Index = Index[1:end .!= i]

    if i <= idx
        i = idx - 1
    else
        i = idx
    end

end
cost = cost + t[I[end],1]

println("Total Time: ", cost)

function minn(list)
    N = 1:length(list)
    qvl = list .!= 0
    N = N[qvl]
    list = list[qvl]
    mini = minimum(list)
    idx = minimum(N[list .== mini])
    return mini, idx
end


function CheckCost(table,path)
    n = 1:size(table,1)
    cost = 0
    for j in n[1:end-1]
        #print("Checking index ",j, "\n")
        in_ = path[j]
        out_ = path[j+1]
        cost = cost + table[in_,out_]
    end
    return cost + table[path[end],1]
end


T = t

n = 1:length(T[:,1])

i = 1
I = Array(n)
I[1] = i
Index = Array(n)
cost = 0

println("Test")
for j in n[1:end-1]
    liste = T[i,:]
    #print("i: ", i, "\n")
    #print(liste)
    mini, idx = minn(liste)
    cost = cost + mini
    println(j, ": Going from customer ", I[j] - 1, " to ", Index[idx] - 1, " with cost ", mini)

    T = T[1:end .!= i , 1:end .!= i] #Remove index i from table T
    I[j+1] = Index[idx]
    Index = Index[1:end .!= i]

    if i <= idx
        i = idx - 1
    else
        i = idx
    end

end
println( "Going from customer ", I[end] - 1, " to Home with cost ", t[I[end],1])
cost = cost + t[I[end],1]

println("Total Time: ", cost)
