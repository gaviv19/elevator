
class Elevator

	attr_accessor :current_floor, :direction, :passengers, :destination

	def initialize(starting_floor, elevator_strategy)
		@elevator_strategy = elevator_strategy
		@current_floor = starting_floor
		@direction = 'waiting'
		@destination = Array.new
		@passengers = Array.new
	end

	#add passengers
	def add_passengers(*passengers)
		passengers.each {|p| @passengers << p}
	end

	#unload passengers
	def unload_passengers(*passengers)
		passengers.each {|p| @passengers.delete(p)}
	end

	#add destination to start queue
	def add_destination(f)
		@destination.unshift(f)
	end

	#update queue if arrived at dest
	def arrived_at_destination
		@destination.pop
	end

	#return self's next dest
	def next_destination
		@destination[@destination.length - 1]
	end

	#return true if self has f on queue
	def has_destination?(f)
		if @destination.include?(f)
			true
		else
			false
		end
	end

	#request for next move from elevator_strategy at every tick
	def clock_tick
		@elevator_strategy.request_strategy(self)
	end

	def state
		false
	end

	def force_next_destination(f)
		if @destination.include?(f)
			@destination.delete(f)
			@destination.push(f)
		else
			@destination.push(f)
		end
	end

	#setting a new direction
	def set_direction(direc)
		@direction = direc
	end

	#returns true if arrived at destination
	def at_dest?
		if self.next_destination == @current_floor
			true
		else
			false
		end
	end
	
end

