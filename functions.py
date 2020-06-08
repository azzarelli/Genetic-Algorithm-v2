import random
from datetime import datetime

random.seed(datetime.now())

# random constants
randNum1 = random.randint(1, 10) # small random factor for intelligence passed on 

# strength is dominant trait
def child_str(ONE, TWO): # rating 10
    if(ONE >= TWO):
        return ONE
    else:
        return TWO

# intelligence is neither dominant it is taught
def child_intel(ONE, TWO): # rating 8
    
    if(((ONE and TWO) > 6) and (randNum1 > 1)): # if both parent are intelligent the child is super intelligent
                                            # additionally 10% chance of this not passing down
        return random.randint(7,8)
    elif(((ONE or TWO)> 6 ) and (randNum1 > 1)): # if one of the parents are intelligent then the child still has a chance
        return random.randint(5, 8)
    elif(((ONE or TWO) == 0) and (randNum1 > 1)): # if one parent is not intelligent the child is not so
        return random.randint(0, 3)
    else:
        return int((ONE + TWO)/2) # otherwise the child is an accumulation of both
