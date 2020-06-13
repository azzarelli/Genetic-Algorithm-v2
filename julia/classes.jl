
mutable struct people

    beauty::Int32
    strength::Int32
    intelligence::Int32

    health::Int32
    fit::Int32
    surv::AbstractFloat
    age::Int32
    children::Int32
    prone_to_illness::AbstractFloat

    people(beauty, strength, intelligence, r) = new(beauty,strength,intelligence, 
    100, beauty+strength+intelligence, (beauty+strength+intelligence)/20, 0, 0, r)


end