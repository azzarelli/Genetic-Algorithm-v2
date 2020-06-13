#=
    Using Julia to improve speeds of running my genetic algorithm.
    Refer to main.py for further explainations
=#

# Ironically classes.jl does not have any classes as Julia does not have Object, instead it holds
#   the person structure
include("./classes.jl")
export people

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

alive_num = length(population)

for obj in population
    if (obj.surv >= 0.7)
        push!(alive, obj)
        push!(beauty, obj)
    end
end


