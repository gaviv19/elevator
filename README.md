# elevator

<a href="https://codeclimate.com/github/gaviv19/elevator"><img src="https://codeclimate.com/github/gaviv19/elevator/badges/gpa.svg" /></a>

April, 2015
Brandeis University
cosi 105b final assignement -- "elevator"
Aviv Glick

**********************************************

How to use:

You can set as many elevators, floors or people you want in the building.
The default is 5 floors, 1 elevator, and three people (2 at the bottom floor, 1 at the top floor)

Simply set your own configuration in the simul.rb file.

**********************************************

The idea behind the app:

My elevator program's core idea is that there is one class responsible for the elevator strategy in the building.
All other classes are "dumb".

The motive for this idea was the single responsibility principle: I wanted to minimize the possibility that any
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
field. Another example is the law of demeter, in which I paid close attention to make sure classes only talk to their immediate 
friends (an elevator, for example, can tell on which floor ("friend") it currently is, but has not idea how many passengers 
("friends of friend") are waiting there). Or, I made sure that the simulation class does not know what state every class is in.
Rather, it simply calls for a "state" class in every class, and I implemented that class so that they know how to handle this call
and what to return. Same goes for the clock_tick class - simply called by simluation, which has no idea what object it is calling, but
trusts that this object implements the clock_tick class.

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

Building:

My building is represented as a container of floors and elevators. It can add floors and elevators, and registers them at the
simulator class (so they won't have to know about it). The building is sort of like the "parent" of the floors and elevators;
It is still an object with states and behaviour, but it knows a little more them floors and elevators do. The elevator_strategy
class thus relies on the building class to provide the right array of floors and elevators, as well as other behavior such as
"compare". Still, the building is just returning a bunch of information, and still not making any calls regarding the strategy.



