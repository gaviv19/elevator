require_relative './elevator_strategy'

class Floor

	attr_accessor :passengers, :elev_arriving_up, :elev_arriving_down

	def initialize(elevator_strategy)
		@elevator_strategy = elevator_strategy
		@passengers = Array.new
		@make_new_request = false
		@elev_arriving_up = false		#mark true if there is an elevator coming up to this floor, than goes up
		@elev_arriving_down = false		#same as above if elevator than goes down.
	end

	def add_passengers(*passengers)
		passengers.each do |p| 
			if not p.get_floor_dest.nil?
				@passengers << p
				@make_new_request = true
			end
		end
	end

	def unload_passenger(p)
		@passengers.delete(p)
	end

	def clock_tick
		@elevator_strategy.has_incoming_elevators?(self)
		if not @passengers.empty? && @make_new_request == false
			@elevator_strategy.request_elevator(self)
			@make_new_request = false
		end
	end

	def state
		false
	end
		

end