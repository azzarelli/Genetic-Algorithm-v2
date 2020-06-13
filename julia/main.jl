#=
    Using Julia to improve speeds of running my genetic algorithm.
    Refer to main.py for further explainations
=#

# Ironically classes.jl does not have any classes as Julia does not have Object, instead it holds
#   the person structure

include("./classes.jl")

include("./function.jl")
export child_str, child_int, child_beau

using Random
using Dates
using Plots

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
    push!(population, people(b,s,i, rand()))

    population[i].prone_to_illness = rand()
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

# First Gen Reproduction
for i in eachindex(alive_num-1) # 1 to alive-1 , writing eachindex segfaults
    for j in Array(i+1:alive_num) # axes((i+1), (alive_num-1)) # i+1 to alive - 1, to do range without seg-faults
        if (randNum == 1) && (@inbounds beauty[i] == beauty[j])
            i = child_int(population[i].intelligence, population[j].intelligence, rand(0:5))
            s = child_str(population[i].strength, population[j].strength)
            b = child_beau(population[i].beauty, population[j].beauty, rand(0:10))
            push!(population, people(b, s, i, rand()))
        end
    end
end

push!(track_size, length(population))

# Initialise Tracking Values
num_str = 0
typeof(num_str)
num_intel = 0
num_beau = 0


for obj in population
    if obj.beauty == 2
        global num_beau += 1
    end
    if obj.strength == 10
        global num_str += 1
    end
    if obj.intelligence == 8
        global num_intel += 1
    end
end

push!(track_intelligence, num_intel)
push!(track_strength, num_str)
push!(track_beauty, num_beau)

year = 1

#=
    The first generation and children has been developed
        Now need to generate the rest of the generations using while loops 
=#

while year < 150
    # Every generation has a new seed
    time = Dates.Time(Dates.now())
    Random.seed!(Dates.value(time))

    # Generate random constants to use later
    randNum1 = rand()
    randNum2 = rand(0:2)

    alive = []
    beauty = []

    global population

    # Determine who survives
    for obj in population
        if obj.surv >= 0.6 # Is their survival attribute high enough to survive
            if obj.intelligence > randNum2 # death by non-intelligence, the less intellligent have higher likelihood of dying
                if obj.age < rand(75:100) # Pehaps old-age can kill an individual
                    if obj.health > 0
                        push!(alive, obj)
                        push!(beauty, obj.beauty)
                    end
                end
            end
        end
    end
    
    alive_num = length(alive)
    population = alive # pass on those that survived as the living population

    # Deteriorate Health for Individuals
    for obj in population
        obj.health = obj.health - convert(Int, round(10 * (obj.prone_to_illness)))
        if obj.age > 80
            obj.health = obj.health - convert(Int32, round(obj.age/80))
        end
    end


    for (i,j) in zip(eachindex(alive_num-2), 2:alive_num-1)
        randNum = rand(0:10)
            if randNum == 1 && beauty[i] == beauty[j+1]
                if population[i].children < 5 && population[j+1].children < 5
                    if population[i].age > 25 &&  population[j+1].age > 25 && population[i].age < 60 && population[j+1].age < 60
                        
                        println(i, j+1)
                         i = child_int(population[i].intelligence, population[j+1].intelligence, rand(0:5))
                        
                         s = child_str(population[i].strength, population[j+1].strength)
                        
                         b = child_beau(population[i].beauty, population[j+1].beauty, rand(0:10))
                        
                        if randNum1 < 0.004 # 0.4% of twins
                            push!(population, people(b, s, i, rand()))
                            push!(population, people(b, s, i, rand()))  
                        elseif randNum1 < 0.00412 # 0.012% of triplets
                            push!(population, people(b, s, i, rand()))  
                            push!(population, people(b, s, i, rand()))  
                            push!(population, people(b, s, i, rand()))  
                        else
                            push!(population, people(b, s, i, rand()))  
                        end
                    end 
                end
            end
        
    end


    # Age a population 
    for obj in population
        obj.age += 1
    end

    # reset tracking values to 0 
    num_str = 0 
    num_intel = 0
    num_beau = 0

    push!(track_size, length(population))

    # Develop tacking values
    for obj in population
        if(obj.beauty == 2)
             num_beau += 1
        end
        if(obj.strength == 10)
             num_str += 1
        end
        if(obj.intelligence == 8)
             num_intel += 1
        end
    end

    # Commit tracking values
    push!(track_intelligence, num_intel)
    push!(track_strength, num_str)
    push!(track_beauty, num_beau)
    global year += 1

end


#========================================================================
Graphing using Plotly lib
==========================================================================#

step = []

for i in eachindex(length(track_size))
    push!(step, i)
end

trace1 = [
  "x" => step,
  "y" => track_size,
  "mode" => "markers",
  "type" => "scatter"
]
trace2 = [
  "x" => step,
  "y" => track_beauty,
  "mode" => "lines",
  "type" => "scatter"
]
trace3 = [
  "x" => step,
  "y" => track_intelligence,
  "mode" => "lines+markers",
  "type" => "scatter"
]
trace4 = [
  "x" => step,
  "y" => track_strength,
  "mode" => "lines+markers",
  "type" => "scatter"
]
data = [trace1, trace2, trace3, trace4]

layout = ["legend" => [
    "y" => 0.5,
    "traceorder" => "reversed",
    "font" => ["size" => 16],
    "yref" => "paper"
  ]]


  p = plot(step, track_size)

  # induce a slight oscillating camera angle sweep, in degrees (azimuth, altitude)
  plot!(p[1], camera = (10 * (1 + cos(i)), 40))
