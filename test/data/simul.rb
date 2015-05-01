require_relative './simulation'
require_relative './building'
require_relative './floor'
require_relative './person'


simul = Simulation.new()
building = Building.new(simul)
number_of_elevators = 1 		
number_of_floors = 5			
building.add_floors(number_of_floors)
building.add_elevators(building.bottom_floor, number_of_elevators)
person1 = Person.new(building.floor(number_of_floors-1), simul, building)
person2 = Person.new(building.floor(number_of_floors-1), simul, building)
person3 = Person.new(building.floor(number_of_floors-3), simul, building)
building.bottom_floor.add_passengers(person1, person2)
building.top_floor.add_passengers(person3)

simul.run(13)

