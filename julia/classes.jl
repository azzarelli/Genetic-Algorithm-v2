mutable struct People
    parent::Union{Nothing, People}

    beauty::Int64
    strength::Int64
    intelligence::Int64

    health::Int64
    fit::Int64
    surv::AbstractFloat
    mutation::AbstractFloat

    age::Int64
    children::Int64
    prone_to_illness::AbstractFloat

end


People(parent::People) = People(parent,0,0,0  ,0,0,0,   0,0,0,0)
People(num::Int64, num1::Int64) = People(nothing,0,0,0  ,0,0,num1, 0,  num,0,0)
People(beauty::Int64, strength::Int64, intelligence::Int64, r1,r2) = People(nothing, beauty,strength,intelligence, 100, beauty+strength+intelligence, (beauty+strength+intelligence)/20, r1, 0, 0, r2)