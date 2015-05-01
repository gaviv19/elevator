require_relative './simulation'
require_relative './building'
require_relative './floor'
require_relative './person'


number_of_elevators = 1
number_of_floors = 5

sim = Simulation.new()

bld = Building.new(sim)


bld.add_floors(number_of_floors)
bld.add_elevators(bld.bottom_floor, number_of_elevators)

pers1 = Person.new(bld.floor(number_of_floors-1), sim, bld)
pers2 = Person.new(bld.floor(number_of_floors-1), sim, bld)
pers3 = Person.new(bld.floor(number_of_floors-3), sim, bld)

bld.bottom_floor.add_passengers(pers1, pers2)
bld.top_floor.add_passengers(pers3)



sim.run(1)

