#=
    Using Julia to improve speeds of running my genetic algorithm.
    Refer to main.py for further explainations
=#

# Ironically classes.jl does not have any classes as Julia does not have Object, instead it holds
#   the person structure
include("./classes.jl")
export people

include("./function.jl")
export child_str, child_int, child_beau

using Random
using Dates

time = Dates.Time(Dates.now())
seedTime = Dates.value(time)
Random.seed!(seedTime)

track_size = []
track_beauty = []
track_strength = []
track_intelligence = []

population = [] # Create an array where we will store the individual's info
alive = [] # Create an array where we store those that survive
beauty = [] # Create array to store the level of beauty of individuals

children_num = 0

b = rand(0:2)
s = rand(0:10)
i = rand(0:8)

for i in 1:100
    push!(population, people(b,s,i))
end


for obj in population
    if (obj.surv >= 0.7)
        push!(alive, obj)
        push!(beauty, obj.beauty)
    end
end

population = alive
alive = []

alive_num = length(population)

randNum = rand(0:5)

for i in 1:(alive_num-1)
    for j in (i+1):(alive_num)
        if (randNum == 1) && (beauty[i] == beauty[j])
            i = child_int(population[i].intelligence, population[j].intelligence, rand(0:5))
            s = child_str(population[i].strength, population[j].strength)
            b = child_beu(population[i].beauty, population[j].beauty, rand(0:10))

            println(b, s, i)
            push!(population, people(b, s, i))
        end
    end
end

#alive_num = length(population)
#println(alive_num)
println(length(population))
