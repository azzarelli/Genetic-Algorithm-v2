
mutable struct people

    beauty::Int
    strength::Int
    intelligence::Int

    health::Int
    fit::Int
    surv::AbstractFloat
    age::Int
    children::Int

    people(beauty, strength, intelligence) = new(beauty,strength,intelligence, 100, beauty+strength+intelligence, (beauty+strength+intelligence)/20, 0, 0)


end