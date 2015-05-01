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

	def add_floors(number_of_floors)
		number_of_floors.times do |f| 
			f = Floor.new(@elevator_strategy)
			@flrs << f
			@sim.register(f)
		end
	end

	def add_elevators(bottom_floor, number_of_elevators)
		number_of_elevators.times do
			e = Elevator.new(bottom_floor, @elevator_strategy)
			@elevators << e
			@sim.register(e)
		end
	end

	def bottom_floor
		@flrs.first
	end

	def top_floor
		@flrs.last
	end

	def clock_tick
		false
	end

	def floor(floor_number)
		@flrs[floor_number]
	end

	def floor_number(f)
		@flrs.index(f)
	end

	def state
		@flrs.each do |f|
			puts "Floor #{@flrs.index(f)} has #{f.passengers.length} passengers waiting."
		end
		@elevators.each do |e|
			puts "Elevator #{@elevators.index(e)} is in floor #{@flrs.index(e.current_floor)}, #{e.direction} with #{e.passengers.length} passengers"
		end
	end

	def compare_f(f1, f2)
		#puts "#{self.floor_number(f1) - self.floor_number(f2)}"

		return (self.floor_number(f1) - self.floor_number(f2))
	end



end
