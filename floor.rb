require_relative './elevator_strategy'

class Floor

	attr_accessor :passengers, :elev_coming

	def initialize(elevator_strategy)
		@elevator_strategy = elevator_strategy
		@passengers = Array.new
		@make_new_request = false		#make a request if not all requests were made
		@elev_coming = false			#mark true if there is an elevator coming up to this floor
	end

	#add passengers to the floor
	def add_passengers(*passengers)
		passengers.each do |p| 
			if not p.get_floor_dest.nil?
				@passengers << p
				@make_new_request = true
			end
		end
	end

	#unloads passengers from the floor
	def unload_passenger(p)
		@passengers.delete(p)
	end

	#make requests to elevator_strategy at every tick, 
	#IF there are passengers waiting and they have not made a request yet
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