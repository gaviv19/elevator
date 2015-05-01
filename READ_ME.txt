my elevator program's core idea is that there

The motive for his idea was the single responsibility principle: I wanted to minimize the possibility that any
object would know much about another object. For example, I wanted the floor to be a floor, and if it has any passengers on it
waiting for an elevator, it will not have to handle calling all elevator and see who is available. 
Therefore, I have written a class called "elevator_strategy", whose responsibility is "to decide on a building's elevator operations 
based on floor requests". The class thus is the "puppeteer" in my app.

Each floor, person or elevator send requests to the elevator_strategy to handle, if they are in any need of on.

Floor:

Each floor does not know about the other floors in the building (or elevators), or even about the building itself.
All it has is an array of passegners on it (does not know whether or not they need an elevator), it knows if there is an
elevator coming toward it, and at every tick it can call the elevator_strategy class IF it should make a new request.

Person:

Every person knows if they are on an elevator, or what floor they are on. They know their destination, and if they have arrived
at their destination. At every tick they check if they have arrived, and if so, update their internal states, and tells the elevator
they have unloaded it and the floor they are there.

Elevator:

Each floor knows everything about itself and nothing about others: it has an array of passengers, a queue for destinations,
it knows its moving state (up, down, or wait), it knows its current floor, and at every tick it calls elevator_strategy to 
ask for its next move. Thus, it simply receives orders from elevator_strategy without asking any questions.

Elevator_Strategy:

This class is the brain. It knows about which building operates it, thus has permission to look at the buildings array of floors
and array of elevators and decide, based on an overall STRATEGY, what should be each elevator's next move, as well as their future moves.
I aspired to implement as many design patterns as I could while enhancing the intelligence of the class. For example,
the "tell don’t ask" principle is used by implementing a "compare" method in the Building class, which tells the elevator_strategy class which floor is higher than the other, instead of checking it directly. Also, the elevator class has a method to be called by another class if the elevator needs to change direction; thus, the method is called, but no one else but the elevator knows about the direction 
field. Another example is the law od demeter, in which I paid close attention to make sure classes only talk to their immediate 
friends (an elevator, for example, can tell on which floor ("friend") it currently is, but has not idea how many passengers 
("friends of friend") are waiting there).

The original strategy was very complicated. So complicate, that while I was getting A's for the design of all of my classes
in CodeClimate, I would get an F for the elevator strategy, mostly for complexity of methods. Even though I tried to minimize
its complexity, CodeClimate was still complaining, so I has to change the strategy to a simpler one just for the sake of a 
better grade. The original strategy had the following if statement that checked "if elevator e is coming toward floor f, and has no more than one destination in its queue, and either [person p needs up AND e continues up) OR [p needs down AND e continues down], then do the following...":

	if e.destination.length <= 1 && ( (@building.compare_f(p.get_floor_dest, f) > 0 && @building.compare_f(f, e.current_floor) > 0 && @building.compare_f(e.next_destination, f) > 0 && e.direction == 'going up') || (@building.compare_f(p.get_floor_dest, f) < 0 && @building.compare_f(f, e.current_floor) < 0 && @building.compare_f(e.next_destination, f) < 0 && e.direction == 'going down') )

This is partly why CodeClimate was complaining. In the "real world" I would have probably kept this if statement (adding clear comments),
but for this assignment I have the class simplified for the sake of good design (the core value in this assignment):

	When a floor needs an elevator,
		if available pick a standing elevator on this elevator.
		else pick an elevator moving to this floor.
		else pick a standing elevator on another floor.
		else wait for the next tick.
