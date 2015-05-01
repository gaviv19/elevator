#deciding on the elevator operations based on floor requests

class ElevatorStrategy

	def initialize(building)
		@building = building
	end

	#handle elevator requests from floors
	def request_elevator(f)
		set_up = false
		set_down = false
		p_to_unload = Array.new()
		f.passengers.each do |p|
			if (not p.get_floor_dest.nil?) && p.elevator.nil?
				@building.elevators.each do |e|	
					if e.current_floor == f && e.direction == 'waiting'		#if e is in f and waits
						p.get_on_elevator(e)
						e.add_passengers(p)
						p_to_unload.push(p)
						unless e.has_destination?(p.get_floor_dest)
							e.add_destination(p.get_floor_dest)
						end
					elsif (@building.compare_f(f, e.current_floor) > 0 && e.direction == 'going up') || (@building.compare_f(f, e.current_floor) < 0 && e.direction == 'going down') #
						if e.next_destination != f 
							e.force_next_destination(f)
						end
						set_up = true	
					elsif e.direction == 'waiting'
						e.add_destination(p.get_floor_dest)
						set_up = true
					end 				#else, if no e in either criteria, wait for the next tick to handle the floor
				end
			end
		end
		if set_up
			f.elev_arriving_up = true 
		end
		if set_down
			f.elev_arriving_down = true
		end
		p_to_unload.each { |p| f.unload_passenger(p) }
	end
	
	#decide the elevator e's next move
	def request_strategy(e)
		if e.direction == 'waiting'	&& (not e.next_destination.nil?)											  #if waiting
			if @building.compare_f(e.next_destination, e.current_floor) > 0	  #and needs to go up, go up
				e.set_direction('going up')
			elsif @building.compare_f(e.next_destination, e.current_floor) < 0  #else, if needs down, go down
				e.set_direction('going down')
			end
		elsif e.at_dest?					 								 #if reached destination, stop and open doors
				e.arrived_at_destination
				e.set_direction('waiting')
		elsif not e.next_destination.nil?
			if @building.compare_f(e.next_destination, e.current_floor) > 0 #continue go up if needed
				e.set_direction('going up')
				e.current_floor = @building.floor(@building.floor_number(e.current_floor) + 1)
			else 																	#continue go down if needed
				e.set_direction('going down')
				e.current_floor = @building.floor(@building.floor_number(e.current_floor) - 1)
			end
		else 																		 #stop for emergency
			e.set_direction('waiting')
		end
	end

	#check for the floor if it has incoming elevators
	def has_incoming_elevators?(f)
		f.elev_arriving_down = false
		f.elev_arriving_up = false
		@building.elevators.each do |e|
			if e.next_destination == f
				if e.direction == 'going down'
					f.elev_arriving_down = true
				else
					f.elev_arriving_up = true
				end
			end
		end
	end


end

