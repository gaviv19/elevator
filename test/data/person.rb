class Person

	def initialize(floor_dest, sim, bld)
		@floor_dest = floor_dest
		@on_elevator = nil
		@elevator_strategy = bld.elevator_strategy
		sim.register(self)
	end

	def get_on_elevator(e)
		@on_elevator = e
	end

	def elevator
		@on_elevator
	end

	def clock_tick
		if not @on_elevator.nil?
			@elevator_strategy.in_dest?(self)
		end
	end

	def get_floor_dest
		@floor_dest
	end

	def set_floor_dest(f)
		@floor_dest = f
	end

	def state
		false
	end

end