# pokemon-catcher
A repository displaying solutions to problems presented with a pokemon theme; Optimal allocation, Node optimization and a Dynamic traveling salesman.
Each problem has a "main" and "utility" file run to test each algorithm, the last file named p1, p2a or p2b is where the algorithm (coded from scratch) resides.
Below is a description of each of the problems and algorithms. Further more detailed explainations of the algorithms can be found in the write-ups located in each of the respective files.


# Optimal Allocation: Where should we put the Pokestops? 

Niantic is paying you big bucks to come up with an algorithm that helps them dynamically determine where Poke-stops should be located on a map. The information available will be the population density at each cell on the map, and the number of stops that should be on that map. The objective is to place the stops at cells where they are as near to as many people as possible so that it is convenient for them to visit the stops.
	 
Problem statement:

Inputs to your algorithm:
•	Map showing population density at each cell
•	Number of stops that Niantic wants on this map

Output. 
•	Your algorithm is expected to make recommendations as to where the stops should be placed on the map, and return the coordinates of these cells. The “quality” of your recommended stops will be scored (details about scoring later).

Algorithm:

arguments: 
  pop_map: a 2D array of integers, representing the population density at each cell
            e.g. for map0, pop_map will be:
                 [[2,5,5,1,3], [8,4,4,0,2], [1,5,2,0,6]]
   number_of_stops: an integer, representing the number of pokestops this method is expected 
                    to come up with and return. You can assume that this is always a positive  
                    number, which is also smaller than the total number of cells in pop_map.
 returns: the coordinates of the recommended pokestops as a 2D array. 
          e.g. this method may return [[1,0], [0,2] and [2,4]] to represent the (y,x) coordinates 
          of three selected stops (assuming number_of_stops is 3).
          Do ensure that:
            - each returned coordinate is valid (i.e. there is such a cell in the pop_map), and
            - the length of the returned array must match number_of_stops 
              (i.e. there should be number_of_stops pair of coorindates).
            
            
            
# Node Optimization: How many pokestops?

Your algorithm will decide the number of stops to place on the map (minimum: 1, max: number of cells on map), and the selected positions of each stop. The objective of your algorithm is to determine the number and positions of your stops so that the total cost is as low as possible. Here is how the total cost is calculated: 

Total cost = 	(i) cost of distance to each stop for the entire population + 
(ii) cost of each stop based on the cost map

(i) will be calculated in the same way as optimal allocation (in the same unit dollar currency as cost_map).

Algorithm:

arguments: 
   pop_map: a 2D array of integers, representing the population density at each cell
            e.g. for map0, pop_map will be:
                 [[2,5,5,1,3], [8,4,4,0,2], [1,5,2,0,6]]
             You can assume that the smallest integer in pop_map is 0
   cost_map: a 2D array of floats, representing the cost of locating a pokestop at each cell
             e.g. for map0, cost_map can be:
                 [[10,10,20,10,10], [10,30,30,10,10], [10,30,10,5,10]]
             You can assume that all the values in cost_map are positive.
             You can assume that cost_map and pop_map have the same dimensions.

 returns: the coordinates of the recommended pokestops as a 2D array. 
          e.g. this method may return [[1,0], [0,2] and [2,4]] to represent the (y,x) coordinates 
          of three selected stops (assuming that you decide to have 3 stops on the map).
          Do ensure that:
            - each returned coordinate is valid (i.e. there is such a cell in the pop_map), and
            - the length of the returned array must be at least 1 (i.e. at least 1 stop returned)



# Dynamic Traveling Salesman: Catch them all!
Your algorithm needs to come up with a recommended route that the current player can take to catch Pokemons with as high an accumulated CP as possible, within the time available to the player. Remember: it’s not the number of Pokemons that can be caught, but the total cumulative CP of all the Pokemons caught that matter, and that the recommended route MUST NOT take longer than the player’s end_time.

You will be given the following information:
(i)	list of known Pokemon positions, 
(ii)	the CP of the Pokemon at each position (the actual Pokemon type is irrelevant; we are only interested in the CP),
(iii)	the respective time windows that each Pokemon is expected to appear at each position,
(iv)	the current position of the player; this will be the start and end positions of your recommended route
(v)	end time; the time available for the current player for this route. 

Algorithm:

arguments: 
   curr_pos : 1D array of integers. Current player's position [y, x]
   end_time : integer. Time that player must get back to curr_pos by
   pmap     : 2D array of integers. The Combat Points (CP) of the Pokemons at each position is in this array. A value of -1 means that there is no Pokemon there.
   tws      : (time window start) 2D array of integers. The "starting time" when the Pokemon at each position will appear.
   twe      : (time window end)   2D array of integers. The "ending time" when the Pokemon at each position will disappear. You can assume that the time_window_end will always be the same or later (bigger) than the corresponding values in tws.              

 returns: a 2D array showing all the positions on the route, and the waiting time (if any) at each position.
          e.g. [[0, 4, 0], [2, 3, 0], [0, 3, 0], [0, 2, 2.7], [0, 4, 0]]
       Do ensure that:
       - the first element in the returned array is curr_pos + waiting time. ([0, 4] is the starting/ending position in the e.g. above)
       - the last element in the returned array is curr_pos + waiting time.
       - the coordinates must be integers. The waiting time can be a float (e.g. 2.7).
