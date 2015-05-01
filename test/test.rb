 require 'minitest/autorun'
 require_relative './data/building'
 require_relative './data/elevator'
 require_relative './data/elevator_strategy'
 require_relative './data/floor'
 require_relative './data/person'
 require_relative './data/simul'
 require_relative './data/simulation'
 

 describe Simulation do
	before do
		number_of_elevators = 1
		number_of_floors = 3
		@sim = Simulation.new()
		@bld = Building.new(@sim)
		@bld.add_floors(number_of_floors)
		@bld.add_elevators(@bld.bottom_floor, number_of_elevators)
		@pers1 = Person.new(@bld.floor(number_of_floors-1), @sim, @bld)
		@pers2 = Person.new(@bld.floor(number_of_floors-1), @sim, @bld)
		@pers3 = Person.new(@bld.floor(number_of_floors-3), @sim, @bld)
		@bld.bottom_floor.add_passengers(@pers1, @pers2)
		@bld.top_floor.add_passengers(@pers3)
	end

  it "has the right amount of agents" do
    @sim.agents.must_equal 8
    puts "#{@sim.agents.length}"
  end
end

