require_relative './elevator_strategy'
require_relative './elevator'
require_relative './floor'


class Building

	attr_accessor :elevators, :elevator_strategy

	def initialize (sim)
		@elevators = Array.new
		@flrs = Array.new
		@elevator_strategy = ElevatorStrategy.new(self)
		sim.register(self)
		@sim = sim
	end

	#add floors to the building
	def add_floors(number_of_floors)
		number_of_floors.times do |f| 
			f = Floor.new(@elevator_strategy)
			@flrs << f
			@sim.register(f)
		end
	end

	#add elevators to the building
	def add_elevators(bottom_floor, number_of_elevators)
		number_of_elevators.times do
			e = Elevator.new(bottom_floor, @elevator_strategy)
			@elevators << e
			@sim.register(e)
		end
	end

	#return the bottom floor of the building
	def bottom_floor
		@flrs.first
	end

	#return the top floor of the building
	def top_floor
		@flrs.last
	end

	#return the floor object by floor number
	def floor(floor_number)
		@flrs[floor_number]
	end

	#return the floor number by a floor object
	def floor_number(f)
		@flrs.index(f)
	end

	#compare foor objects by their floor number
	def compare_f(f1, f2)
		(self.floor_number(f1) - self.floor_number(f2))
	end

	def clock_tick
		false
	end

	#return the current state of the building: how many people on each floor, where is each elevators and where are the people
	def state
		@flrs.each do |f|
			puts "Floor #{@flrs.index(f)} has #{f.passengers.length} passengers waiting."
		end
		@elevators.each do |e|
			puts "Elevator #{@elevators.index(e)} is in floor #{@flrs.index(e.current_floor)}, #{e.direction} with #{e.passengers.length} passengers"
		end
	end


end
