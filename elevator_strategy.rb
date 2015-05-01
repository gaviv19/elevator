#deciding on the elevator operations based on floor requests

class ElevatorStrategy

	def initialize(building)
		@building = building
	end

	#handle elevator requests from floors
	def request_elevator(f)
		p_to_unload = Array.new()
		f.passengers.each do |p|
			if (not p.get_floor_dest.nil?) && p.elevator.nil?
				@building.elevators.each do |e|	
					if e.current_floor == f && e.direction == 'waiting'		# if available pick a standing elevator on this elevator.
						p.get_on_elevator(e)
						e.add_passengers(p)
						p_to_unload.push(p)
						unless e.has_destination?(p.get_floor_dest)
							e.add_destination(p.get_floor_dest)
						end
					elsif (@building.compare_f(f, e.current_floor) > 0 && e.direction == 'going up') || (@building.compare_f(f, e.current_floor) < 0 && e.direction == 'going down') #else pick an elevator moving to this floor.
						if e.next_destination != f 
							e.force_next_destination(f)
						end
						f.elev_coming = true	
					elsif e.direction == 'waiting' #else pick a standing elevator on another floor.
						e.add_destination(p.get_floor_dest)
						f.elev_coming = true	
					end 				#else, if no e in either criteria, wait for the next tick to handle the floor
				end
			end
		end
		update_floors(f, p_to_unload)
	end
	
	def update_floors(f, p_to_unload)
		p_to_unload.each { |p| f.unload_passenger(p) }
	end
	
	#decide the elevator e's next move
	def request_strategy(e)
		if e.direction == 'waiting'	&& (not e.next_destination.nil?)		#if waiting
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
		f.elev_coming = false
		@building.elevators.each do |e|
			if e.next_destination == f
				f.elev_coming = true
			end
		end
	end


end

