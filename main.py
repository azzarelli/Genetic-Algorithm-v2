
# This Genetic algorythm focuses on the more realistic evolution methods that exist - based around three qualities 'Beauty', 'Intelligence', 'Strength'
    # Beauty determines who has sex with who. As with most species attraction dictates who can mate.
        # For the moment only people of the same beauty will mate
    # Strength is a the main contributor to survival - the stronger you are the higher your survival rating is (".surv")
    # Intelligence is a large contributor to survival also - the smarter people have higher survival raiting

    # Survival rating (/11) = Beauty (2) + Strength (5) + Intelligence(4)


from classes import PersonClass # classes.py contains person class
from functions import child_str, child_intel # functions.py contains functions used

import random # for randomness
from datetime import datetime # for random seed

import plotly.graph_objects as go # to plot results

# Set the variables we will use to track the population
track_size = []
track_beauty = []
track_strength = []
track_intelligence = []

random.seed(datetime.now()) # Set the seed

population = [] # Create an array where we will store the individual's info
alive = [] # Create an array where we store those that survive
beauty = [] # Create array to store the level of beauty of individuals

children_num = 0 # set the id given to a new children to identify it as 0

for i in range(100): # initialise the first generation
    population.append(PersonClass(i, random.randint(0,2),random.randint(0,8),random.randint(0,10), 0))

alive_num = len(population) # determine how many are alive

# Who survives the first year
for obj in population:
    if(obj.surv >= 0.6): # harsh world only 40% of people live
        if(obj.age < 3):
            alive.append(obj)
            beauty.append(obj.beauty)

alive_num = len(alive) # re-calculate number alive

# First Gen reproduction
for i in range(0, alive_num):
    
    randNum = random.randint(0,5)
    for j in range(i+1, alive_num):
        if((randNum == 1) and (beauty[i] == beauty[j])): # only 1/5 chance of having children
                                                            # but everyone mates with everyone at same beauty level
            children_num = children_num + 1 # adding to child's id

            child_intelligence = int((alive[i].intelligence + alive[j].intelligence)/2) # determining child's intelligence
            child_strength = child_str(alive[i].strength, alive[j].strength) # and strenght (in functions.py)
           
            alive.append(PersonClass(children_num, beauty[i], child_intelligence, child_strength, 0)) # create the child
            

track_size.append(len(alive)) # track the new # of individuals

# Initialise Tracking Values
num_str = 0
num_intel = 0
num_beau = 0

for obj in population:
    if(obj.beauty == 2):
        num_beau = num_beau + 1
    if(obj.strength == 10):
        num_str = num_str + 1
    if(obj.intelligence == 8):
        num_intel = num_intel + 1

    
track_intelligence.append(num_intel)
track_strength.append(num_str)
track_beauty.append(num_beau)

# Set the year to 1

year = 1


while(year < 150):

    random.seed(datetime.now()) # Seed forever changes

    # Generate Random Constants to be used
    randNum1 = random.random() # number from 0.0 to 1.0, used for twin, triplet, quadruplet chance ... 
    randNum2 = random.randint(0,2) # number between 0 and 2, set threshold for death due to stupidity
    
    alive = [] # re-set alive array
    
    # Determine who survives
    for obj in population:
        if(obj.surv >= 0.6): # harsh world only 40% of people live
            if(obj.intelligence > randNum2): # death by stupidity
                if(obj.age < random.randint(75,100)): # people between ages of 75 and 100 are more likely to die
                                                    # thos younger than these random ages are passed on
                    if(obj.health > 0):
                        alive.append(obj) # track those survived
                        beauty.append(obj.beauty) # track the 'attraction' of all individuals that have survived

    alive_num = len(alive) # caluclate new number of people that have survived

    population = alive # re-calculate the new population

    # Determine health of an individual given their conditions
    for obj in population:
        obj.health = obj.health - (2 * obj.prone_to_illness)
        if(obj.age > 80): # old people age badly - sorry 
            obj.health = obj.health - int(obj.age/80)
    

    # Determine who has children && have them
    for i in range(0, alive_num):
        
        randNum = random.randint(0,10)
        for j in range(i+1, alive_num): # cycle through the population, look for compatible mates
            if((randNum == 1) and (beauty[i] == beauty[j])): # but everyone mates with everyone at same beauty level

                if((alive[i].age > 25)and(alive[j].age>25)and(alive[i].age<55)and(alive[j].age<55)): # age of reproduction becomes a factor

                    if((alive[i].children < 5)and(alive[j].children < 5)): # only mates with someone once a year
                        child_intelligence = child_intel(alive[i].intelligence, alive[j].intelligence)

                        child_strength = child_str(alive[i].strength, alive[j].strength)

                        # Likelihood of having more than one child at once
                        if(randNum1 < 0.004): # 0.40% of having twins and set them
                            alive.append(PersonClass(children_num, beauty[i], child_intelligence, child_strength, 0))
                            alive.append(PersonClass(children_num+1, beauty[i], child_intelligence, child_strength, 0))
                            children_num = children_num + 2
                            alive[i].children = alive[i].children + 2
                            alive[j].children = alive[j].children + 2
                        elif(randNum1 < 0.00412): # 0.012% of having triplets and set them
                            alive.append(PersonClass(children_num, beauty[i], child_intelligence, child_strength, 0))
                            alive.append(PersonClass(children_num+1, beauty[i], child_intelligence, child_strength, 0))
                            alive.append(PersonClass(children_num+2, beauty[i], child_intelligence, child_strength, 0))
                            children_num = children_num + 3
                            alive[i].children = alive[i].children + 3
                            alive[j].children = alive[j].children + 3
                        else: # otherwise have one
                            alive.append(PersonClass(children_num, beauty[i], child_intelligence, child_strength, 0))
                            children_num = children_num + 1
                            alive[i].children = alive[i].children + 1
                            alive[j].children = alive[j].children + 1

    population = alive # set the new population to account for new borns

    # age everyone and return mated count to 0
    for obj in population:
        obj.age = obj.age + 1

    # Reset the array that tracks beauty as those that survives forever changes
    beauty = []

    # Calculate Tracking Values

    num_str = 0 # reset tracking values to 0 
    num_intel = 0
    num_beau = 0

    track_size.append(len(population)) # track the population at the end of the year

    for obj in population: # track the number of individuals who are at max strength or intelligence or beauty
        if(obj.beauty == 2):
            num_beau = num_beau + 1
        if(obj.strength == 10):
            num_str = num_str + 1
        if(obj.intelligence == 8):
            num_intel = num_intel + 1

    
    track_intelligence.append(num_intel)
    track_strength.append(num_str)
    track_beauty.append(num_beau)

    
    print(year)
    year = year + 1 # year increases



# Graphing #################################################################################################################################################################

step = []

for i in range(len(track_size)):
    print(track_size[i], ' ', track_beauty[i], ' ', track_intelligence[i], ' ', track_strength[i])

    step.append(i)

# Graphing Outcome

fig = go.Figure()

# Add traces
fig.add_trace(go.Scatter(x=step, y=track_size,
                    mode='lines+markers',
                    name='Population Size'))

fig.add_trace(go.Scatter(x=step, y=track_beauty,
                    mode='lines+markers',
                    name='# of Most Beautiful'))
fig.add_trace(go.Scatter(x=step, y=track_intelligence,
                    mode='lines',
                    name='# of Most Intelligent'))
fig.add_trace(go.Scatter(x=step, y=track_strength,
                    mode='lines',
                    name='# of Most Strength'))

fig.show()
