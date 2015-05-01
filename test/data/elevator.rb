
class Elevator

	attr_accessor :current_floor, :direction, :passengers, :destination


	def initialize(starting_floor, elevator_strategy)
		@elevator_strategy = elevator_strategy
		@current_floor = starting_floor
		@direction = 'waiting'
		@destination = Array.new
		@passengers = Array.new
	end

	def set_destination(floor)
		@destination << floor
	end

	def add_passengers(*passengers)
		passengers.each {|p| @passengers << p}
	end
	
	def unload_passengers(*passengers)
		passengers.each {|p| @passengers.delete(p)}
	end


	def clock_tick
		@elevator_strategy.request_strategy(self)
	end

	def state
		false
	end

	def add_destination(f)
		@destination.unshift(f)
	end

	def arrived_at_destination
		@destination.pop
	end

	def next_destination
		@destination[@destination.length - 1]
	end

	def has_destination?(f)
		if @destination.include?(f)
			true
		else
			false
		end
	end
	

	def force_next_destination(f)
		if @destination.include?(f)
			@destination.delete(f)
			@destination.push(f)
		else
			@destination.push(f)
		end
	end




end

