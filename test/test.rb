require 'minitest/autorun'
require_relative './data/elevator_strategy'
require_relative './data/elevator'
require_relative './data/building'
require_relative './data/floor'
require_relative './data/person'
require_relative './data/simul'


describe 'elevator' do

	before do
		@simul = Simulation.new()
		@building = Building.new(@simul)
		@number_of_elevators = 1 		
		@number_of_floors = 5			
		@building.add_floors(@number_of_floors)
		@building.add_elevators(@building.bottom_floor, @number_of_elevators)

		@e = @building.elevators[0]
		@f = @building.top_floor
	end

	it 'should add passengers'do
		initial_no_of_p = @e.passengers.length
		person1 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		@e.add_passengers(person1)
		assert_equal @e.passengers.length, (initial_no_of_p + 1)
	end

	it 'should unload passengers' do
		person2 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		@e.add_passengers(person2)
		person_deleted = @e.unload_passengers(person2)
		refute_nil person_deleted
	end

	it 'should return false if self does not have f on queue' do
		assert @e.has_destination?(@f).must_equal false
	end

	it 'should add destination to start queue' do
		old_dest = @e.destination[0]
		@e.add_destination(@f)
		refute_equal old_dest, @e.destination[0]
	end

	it 'should return true if self has f on queue' do
		f = @building.bottom_floor
		@e.add_destination(f)
		assert @e.has_destination?(f).must_equal true
	end
	
	it 'should update queue if arrived at destination' do
		f1 = @e.destination[@e.destination.length - 1]
		f2 = @e.arrived_at_destination
		assert_equal f1, f2
	end
	
	it "should return self's next dest" do
		assert_equal @e.next_destination, @e.destination[@e.destination.length - 1]
	end

	it 'should returns false if not at destination' do
		@e.current_floor = @building.bottom_floor
		@e.force_next_destination(@building.top_floor)
		refute_same @e.next_destination, @e.current_floor
	end

	it 'should returns true if at destination' do
		@e.current_floor = @building.bottom_floor
		@e.force_next_destination(@building.bottom_floor)
		assert_equal @e.next_destination, @e.current_floor
	end


end


describe 'floor' do

	before do
		@simul = Simulation.new()
		@building = Building.new(@simul)
		number_of_elevators = 1 		
		@number_of_floors = 5			
		@building.add_floors(@number_of_floors)
		@building.add_elevators(@building.bottom_floor, number_of_elevators)

		@floor = @building.top_floor
	
	end

	it 'should add passengers to the floor' do
		person1 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		person2 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		initial_no_of_p = @floor.passengers.length
		@floor.add_passengers(person1, person2)
		assert_equal @floor.passengers.length, (initial_no_of_p + 2)
	end

	it 'should unload passengers' do
		person3 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		@floor.add_passengers(person3)
		person_deleted = @floor.unload_passenger(person3)
		refute_nil person_deleted
	end

	it 'should not unload passengers that are not on self' do
		person4 = Person.new(@building.floor(@number_of_floors-1), @simul, @building)
		person_deleted = @floor.unload_passenger(person4)
		assert_nil person_deleted
	end


end

describe 'building' do

	before do
		simul = Simulation.new()
		@building = Building.new(simul)
		number_of_elevators = 1 		
		number_of_floors = 5			
		@building.add_floors(number_of_floors)
		@building.add_elevators(@building.bottom_floor, number_of_elevators)
	
	end

	it 'should add floors' do
		initial_no_of_floors = @building.floor_number(@building.top_floor)
		@building.add_floors(2)
		assert_equal @building.floor_number(@building.top_floor), (initial_no_of_floors + 2)
	end

	it 'should add elevators' do
		initial_no_of_floors = @building.elevators.length
		@building.add_elevators(@building.bottom_floor, 3)
		assert_equal @building.elevators.length, (initial_no_of_floors + 3)
	end

	it 'should return the floor object by floor number' do
		refute_nil @building.floor(4)
	end

	it 'should return the floor number by a floor object' do
		refute_nil @building.floor_number(@building.top_floor)
	end

	it 'should compare floor objects by their floor number' do
		assert_equal @building.compare_f(@building.floor(4), @building.floor(2)), 2
	end

end


describe 'person' do

  before do
		simul = Simulation.new()
		building = Building.new(simul)
		number_of_elevators = 1 		
		number_of_floors = 5			
		building.add_floors(number_of_floors)
		building.add_elevators(building.bottom_floor, number_of_elevators)
	
		@person = Person.new(building.floor(number_of_floors-1), simul, building)
	
		@e = building.elevators[0]
		@f = building.floor(0)

  end

  it 'should not be on elevator' do
    assert_nil @person.elevator
  end

  it 'should be on elevator' do
  	@person.get_on_elevator(@e)
    refute_nil @person.elevator
  end

  it 'should get floor destination' do
    refute_nil @person.get_floor_dest
  end

   it 'should set floor destination to nil' do
  	@person.set_floor_dest(nil)
    assert_nil @person.get_floor_dest
  end

  it 'should set floor destination' do
  	@person.set_floor_dest(@f)
    refute_nil @person.get_floor_dest
  end


end

