
# Determining a child's strength
function child_str(a::Int64, b::Int64)
    if a >= b
        return a
    else
        return b
    end
end

# Determining a child's intelligence
function child_int(a::Int64, b::Int64, rand::Int64)
    if a >= 6 &&  b >= 6 && (rand > 1) # rand is 0 to 5 so 1/5 chance super-intelligence isn't passed on 
        if (a > 7) || (b > 7) # if either parents have full super-intelligence
            return 8
        else # if both parents are super smart but not the top the child just gets 7
            return 7
        end
    elseif (a >= 6 || b >= 6) && (rand > 1) # either parents smart still a chance the kid is too
        if a > 4 && b > 4 && (rand > 2) # now 3/5 chance of passing on intelligence as parents get less intelligen
            return 6
        else 
            return 5
        end
    elseif (a > 3 || b > 3) && rand > 3 #now 2/5 chance of intelligence being passed on
        return 4
    else
        return convert(Int64, round((a + b)/2))
    end
end

function child_beau(a::Int64, b::Int64, rand::Int64)
    if(rand == 10) # chance of being more beautiful than the parents, 1/10
        return convert(Int64, round(((a+b)/2) + 1))
    elseif rand == 3 || rand == 1 # chance of being less attractive, 2/10
        z = (a+b)/2 -1
        z = convert(Int64, round(z))
        z = convert(Int64, sqrt(z * z))      
        return z
    else
        return a
    end
end