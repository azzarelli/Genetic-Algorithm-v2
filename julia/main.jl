#=
    Using Julia to improve speeds of running my genetic algorithm.
    Refer to main.py for further explainations
=#

# Ironically classes.jl does not have any classes as Julia does not have Object, instead it holds
#   the person structure

#include("./classes.jl")

include("./function.jl")
export child_str, child_int, child_beau

using PlotlyJS
using Random
using Dates

time = Dates.Time(Dates.now())
seedTime = Dates.value(time)
Random.seed!(seedTime)

track_size = []
track_beauty = []
track_strength = []
track_intelligence = []

# Create an array where we will store the individual's info
population = People.(rand(0:1, 3),rand(0:1, 3))

println(typeof(population))
 # for derivative calculation
last_population = People.(rand(0:1, 3),rand(0:1, 3))

alive = People.(rand(0:1, 3),rand(0:1, 3)) # Create an array where we store those that survive

beauty = []  # Create array to store the level of beauty of individuals


for i in 1:100
    b = rand(0:2)
    s = rand(2:10)
    int = rand(1:8)

    println(b, " ", s, " ", int )
    push!(population, People(b,s,int, rand(),rand()))
    population[i].prone_to_illness = rand()
end


for obj in population
    if (obj.surv >= 0.5)
        push!(alive, obj)
        push!(beauty, obj.beauty)
    end
end

population = alive
alive = []

alive_num = length(population)

randNum = rand(0:5)

# First Gen Reproduction
for i in 1:alive_num-1 # 1 to alive-1 , writing eachindex segfaults
    for j in 2:alive_num # axes((i+1), (alive_num-1)) # i+1 to alive - 1, to do range without seg-faults
        if (randNum == 1) && (beauty[i] == beauty[j])

            int = child_int(population[i].intelligence, population[j].intelligence, rand(0:5))
            s = child_str(population[i].strength, population[j].strength)
            b = child_beau(population[i].beauty, population[j].beauty, rand(0:10))

            push!(population, People(b, s, int, rand(),rand()))

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

last_population = population
year = 1

#=
    The first generation and children has been developed
        Now need to generate the rest of the generations using while loops 
=#

global old_time = Dates.value(Dates.Time(Dates.now()))
T_time = Dates.value(Dates.Time(Dates.now()))

while T_time - old_time < 1000000000000


    global old_time = T_time
    global T_time = Dates.value(Dates.Time(Dates.now()))
    # Every generation has a new seed
    time = Dates.Time(Dates.now())
    Random.seed!(Dates.value(time))

    # Generate random constants to use later
    randNum1 = rand()
    randNum2 = rand(0:1)

    alive = []
    beauty = []

    global population
    global last_population

    # Determine who survives
    for obj in population
        if obj.surv >= 0.6 # Is their survival attribute high enough to survive
            if obj.intelligence > randNum2 # death by non-intelligence, the less intellligent have higher likelihood of dying
                if obj.age < rand(75:100) && obj.health > 0# Pehaps old-age can kill an individual
                    push!(alive, obj)
                    push!(beauty, obj.beauty)
                    
                end
            end
        end
    end
    
    alive_num = length(alive)
    population = alive # pass on those that survived as the living population
    alive = []

    # Deteriorate Health for Individuals
    for obj in population
        obj.health = obj.health - convert(Int, round(10 * (obj.prone_to_illness)))
        if obj.age > 80
            obj.health = obj.health - convert(Int32, round(obj.age/80))
        end
    end

    if alive_num > 0
        for i in 1:alive_num-2
            obj1 = population[i]
            for j in 1:alive_num-1
                
                obj2 = population[j+1]

                randNum = rand(0:10)


                if randNum == 1 && obj1.beauty == obj2.beauty && obj1.children < 5 && obj2.children < 5
                    if obj1.age > 20 &&  obj2.age > 20 && obj1.age < 55 && obj2.age < 55

                                                
                        int = child_int(obj1.intelligence, obj2.intelligence, rand(0:5))
                        
                        s = obj1.strength >= obj2.strength ? obj1.strength : obj2.strength
                            
                        b = child_beau(obj1.beauty, obj2.beauty, rand(0:10))
                            

                        if randNum1 < 0.004 # 0.4% of twins
                            push!(population, People(b, s, int, rand(),rand()))
                            push!(population, People(b, s, int, rand(),rand()))
                            obj1.children += 3
                            obj2.children += 3
                        elseif randNum1 < 0.00412 # 0.012% of triplets
                            push!(population, People(b, s, int, rand(),rand()))
                            push!(population, People(b, s, int, rand(),rand()))
                            obj1.children += 2
                            obj2.children += 2
                        else
                            push!(population, People(b, s, int, rand(),rand()))
                            obj1.children += 1
                            obj2.children += 1
                        end
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

    last_population = population
    # Commit tracking values
    push!(track_intelligence, num_intel)
    push!(track_strength, num_str)
    push!(track_beauty, num_beau)
    global year += 1

    println(year - 1, "  ")

end



#========================================================================
Graphing using Plotly lib
==========================================================================#

step = []

size = length(track_size)
for i in 1:size
    push!(step, i)

end

trace1 = scatter(;y=track_size, x=step, mode="lines+markers")
trace2 = scatter(;y=track_beauty, x=step, mode="lines")
trace3 = scatter(;y=track_intelligence, x=step, mode="lines")
trace4 = scatter(;y=track_strength, x=step, mode="lines")

data = [trace1, trace2, trace3, trace4]
plot(data)
