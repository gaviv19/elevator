class Simulation
	attr_reader :agents

	def initialize()
		@agents = Array.new
	end

	def register(agent)
		@agents << agent
	end

	def run(count)
		count.times do |tick|
			puts "tick #{tick}"
			@agents.map do |a|
				a.state
				a.clock_tick()
			end
			sleep(1)
		end
	end


end
