class Person

	def initialize(floor_dest, sim, bld)
		@floor_dest = floor_dest
		@on_elevator = nil
		@elevator_strategy = bld.elevator_strategy
		sim.register(self)
	end

	#get self's elevator
	def get_on_elevator(e)
		@on_elevator = e
	end

	#set self's elevator
	def elevator
		@on_elevator
	end

	#get floor dest
	def get_floor_dest
		@floor_dest
	end

	#set floor dest
	def set_floor_dest(f)
		@floor_dest = f
	end

	#update self's position if arrived at destination
	def in_dest?
		e = self.elevator
		if (@floor_dest == e.current_floor && e.direction == 'waiting')
			floor = @floor_dest
			@on_elevator = nil
			@floor_dest = nil
			floor.add_passengers(self)
			e.unload_passengers(self)
		end
	end

	#check if arrived at destination at every tick
	def clock_tick
		if not @on_elevator.nil?
			self.in_dest?
		end
	end

	def state
		false
	end

end