
# project 2a

# arguments: 
#   pop_map: a 2D array of integers, representing the population density at each cell
#            e.g. for map0, pop_map will be:
#                 [[2,5,5,1,3], [8,4,4,0,2], [1,5,2,0,6]]
#             You can assume that the smallest integer in pop_map is 0
#   cost_map: a 2D array of floats, representing the cost of locating a pokestop at each cell
#             e.g. for map0, cost_map can be:
#                 [[10,10,20,10,10], [10,30,30,10,10], [10,30,10,5,10]]
#             You can assume that all the values in cost_map are positive.
#             You can assume that cost_map and pop_map have the same dimensions.
#
# returns: the coordinates of the recommended pokestops as a 2D array. 
#          e.g. this method may return [[1,0], [0,2] and [2,4]] to represent the (y,x) coordinates 
#          of three selected stops (assuming that you decide to have 3 stops on the map).
#          Do ensure that:
#            - each returned coordinate is valid (i.e. there is such a cell in the pop_map), and
#            - the length of the returned array must be at least 1 (i.e. at least 1 stop returned)



def get_pokestops(pop_map, cost_map)

  # returns number_of_stops poke stops randomly within the map
  # this is a non-deterministic working solution, but produces a lousy (high) 
  # quality score for obvious reasons
  
  time = Time.now
  answer = []
  max_y = pop_map.length-1    # y should not go beyond this boundary
  max_x = pop_map[0].length-1 # x should not go beyond this boundary
  
  #uses formula to identify the best midpoint to start from
  number_of_stops = 1
  total_pop = 0
  total_cost = 0
  total_cost_array = []
  
  for y in 0..max_y #initializes total population and total cost
	for x in 0..max_x
		total_pop = total_pop + pop_map[y][x]
		total_cost = total_cost + cost_map[y][x]
		total_cost_array << cost_map[y][x]
	end
  end
	
	no_of_cells = max_x*max_y
	
  avg_cost = total_cost/(max_y*max_x)
  total_cost_array.sort!
  count = 0
  test_hash = Hash.new
  
  for y in 0..max_y #equation to figure out margins
	for x in 0..max_x
		score = number_of_stops* total_cost_array[count] + total_pop*max_x*max_y*0.25/(2**(number_of_stops*3000/(no_of_cells**1.3)))
		#puts "#{number_of_stops} Stops: #{score}"
		test_hash[number_of_stops] = score
		count = count + 1
		number_of_stops = number_of_stops + 1
	end
  end
  
  test_hash = test_hash.sort_by {|key,value|value}
  equation_no = test_hash[0][0]
  
  
  
  
   margin = 0.025*(max_x*max_y)
  lower = equation_no - margin
  upper = equation_no + margin
  lowest = false
  mid = (lower+upper)/2
  difference = max_x*max_y/500
  difference_interval = max_x*max_y/1000
  if difference_interval == 0
	difference_interval = 1
  end
  difference_limit = difference + 3*difference_interval
  test_hash = Hash.new
  
  #for testing
  # for i in lower.round..upper.round
	# number_of_stops = i
	# answer = get_pokestops_with_stops(pop_map, number_of_stops,cost_map)
	# temp = calculate_score_for_map(pop_map, cost_map, answer, false)
	# puts "Number of Stops: #{number_of_stops}, Score: #{temp}"
	# test_hash[number_of_stops] = temp
  # end
  # test_hash = test_hash.sort_by {|key,value|value}
  # real_no = test_hash[0][0]
  # puts "Real Number of Stops: #{real_no}"
  # margin_req = (equation_no - real_no)*100.0/(max_x*max_y)
  # puts "Margin required: #{margin_req}%"
  

  
 
  if difference == 0 
	difference = 1
	end
	went_lower = 0
	went_upper = 0
	stayed = 0
	count = 0
	lowestScore = 0
    if ((mid-difference)>0 && (mid+difference)<(pop_map.length*pop_map[0].length)+1) == false
	
		for i in 1...(0.4*no_of_cells).round
			test_answer = []
			number_of_stops = i
			lowestScore = 0
			temp_array = get_pokestops_with_stops(pop_map, number_of_stops,cost_map)
			for i in 0...temp_array.length-2
					test_answer << temp_array[i][0]
			end
			
			temp = calculate_score_for_map(pop_map, cost_map, test_answer, false)
			if i == 1 
				lowestScore = temp
				answer = test_answer
			elsif lowestScore > temp
				answer = test_answer
				lowestScore = temp
			end
			
		end
	
	else
		#puts "inside here"
		#puts "difference: #{difference}, Limit : #{difference_limit}"
	  while difference != difference_limit 
		count = count +1
		#mid
		if count == 10
				break
		end
		
		mid = (lower+upper)/2
	
		
		if stayed == 1 
			answer1 = answer
			temp1 = lowestScore
		else
		
			map1 = Marshal.load(Marshal.dump(pop_map)) 
			temp_array = get_pokestops_with_stops(map1, mid,cost_map) # answer in format | [y,x] (stop coor), (area_no)| last element are the area coordinates array
			answer1 = []
			temp_area_no = Hash.new
			
			
			area_coordinates = temp_array[(temp_array.length-1)]
			x_areas = temp_array[(temp_array.length-2)]
			for i in 0...temp_array.length-2
				answer1 << temp_array[i][0]
				temp_area_no[temp_array[i][1]] = temp_array[i][0]
			end
			#puts "Stops to area hash : #{temp_area_no}"
			temp1 = calculate_score_for_map_search(map1,cost_map,answer1,temp_area_no,area_coordinates, x_areas)
		end
		
		stayed = 0
		upper1 = mid
		lower1 = mid
		
		# difference before mid
			
		map2 = Marshal.load(Marshal.dump(pop_map)) 
		temp_array = get_pokestops_with_stops(map2, mid-difference,cost_map) # array
		answer2 = []
		temp_area_no = Hash.new
		
		
		area_coordinates = temp_array[(temp_array.length-1)]
		x_areas = temp_array[(temp_array.length-2)]
		for i in 0...temp_array.length-2
			answer2 << temp_array[i][0]
			temp_area_no[temp_array[i][1]] = temp_array[i][0]
		end
		#puts "Stops to area hash : #{temp_area_no}"
		temp2 = calculate_score_for_map_search(map2,cost_map,answer2,temp_area_no,area_coordinates, x_areas)
		
		# difference after mid
		map3 = Marshal.load(Marshal.dump(pop_map)) 
		temp_array = get_pokestops_with_stops(map3, mid+difference,cost_map) # array
		answer3 = []
		temp_area_no = Hash.new
		
		
		area_coordinates = temp_array[(temp_array.length-1)]
		x_areas = temp_array[(temp_array.length-2)]
		for i in 0...temp_array.length-2
			answer3 << temp_array[i][0]
			temp_area_no[temp_array[i][1]] = temp_array[i][0]
		end
		#puts "Stops to area hash : #{temp_area_no}"
		temp3 = calculate_score_for_map_search(map3,cost_map,answer3,temp_area_no,area_coordinates, x_areas)
		
		
	
		if (temp2 < temp1) && (temp3 > temp2)  #the one BEFORE mid is smaller
			lowestScore = temp2
			answer = answer2
			upper = upper1
			
		elsif (temp3 < temp2) && (temp3 < temp1) # the one AFTER mid is smaller
			lowestScore = temp3
			answer = answer3
			lower = lower1
			
		else # both are higher; mid is smallest
			lowestScore = temp1
			answer = answer1
			stayed = 1
			difference = difference + difference_interval
			if difference > difference_limit
				difference = difference_limit
			end
		end
	  end
  end

  
  return answer
end

def calculate_score_for_map_search(map1, cost_map, answer1, temp_area_no, area_coordinates,x_areas)
	#number_of_cells_searched = 0
	temp1=0.0
	#puts "Areas: #{area_coordinates.length}"
	#time_for_stops_cum = 0.0
	for i in 0...area_coordinates.length
				
				#areas to search for area
				stops_to_search = []
				area_to_search = []
				#count to expand search radius
				count = 1
				#puts "x_areas: #{x_areas}"
				
				
				while stops_to_search.length == 0
					#puts "stops_to_search: #{stops_to_search}"
					#fill area to search
					for x in (i-count)..(i+count)
							area_to_search << x
							
								area_to_search << x + x_areas + count - 1
							
							
								area_to_search << x - x_areas - count + 1 
							
					end
					
					# remove negatives
					temp_area_to_search = []
					for j in 0...area_to_search.length
						if area_to_search[j] >= 0
							temp_area_to_search << area_to_search[j]
						end
					end
					
					#make it uniq
					area_to_search = temp_area_to_search.uniq
					
					#puts "areas to search: #{area_to_search}"
					#change to stops
					
					for j in 0...area_to_search.length
						
						if temp_area_no.has_key?(area_to_search[j])
							
							stops_to_search << temp_area_no[area_to_search[j]]
						end
					end
					count = count + 1
					
				end
				
				
				
				#puts "stops to search for area #{i}: #{stops_to_search}"
				#search for each of the tiles and score
				score_for_area = 0.0 
				for coor in 0...area_coordinates[i].length
					y = area_coordinates[i][coor][0]
					x = area_coordinates[i][coor][1]
					#time_for_stops = Time.now
					
					cell_score = get_score_nearest_pokestop_search(y,x,stops_to_search,map1[y][x])
					
					#time_for_stops = Time.now - time_for_stops
					#time_for_stops_cum = time_for_stops_cum + time_for_stops
					
				
					
					
					temp1 = temp1 + cell_score
					#score_for_area = score_for_area + cell_score
					#fill in area to search
				end
				#puts "Score for area #{i}: #{score_for_area}"
			end
			#puts "Number of Cells Searhed: #{number_of_cells_searched}"
	#calculate score for stops
		#puts "Score before cost: #{temp1} for #{answer1.length} stops"
		
		
	cost_of_positions = 0.0
  for i in 0...answer1.length
	current_stop = answer1[i]
	
	cost_of_curr_position = cost_map[current_stop[0]][current_stop[1]]
	cost_of_positions += cost_of_curr_position
	
  end
  
	
	#puts "Time taken for calculation: #{time_for_stops_cum} "		  
  temp1 = temp1 + cost_of_positions
  return temp1
 end
  

def get_score_nearest_pokestop_search(y, x, stops, population)
  
  lowestScore = 1.0/0.0
  
  # insert distance, to get [y, x, dist] for each stop
 
  for i in 0...stops.length
    stop = stops[i]
    
    temp_dist = distance(stop[0], stop[1], y, x)
	
	
		
	if temp_dist < lowestScore
		lowestScore = temp_dist
		
	end
  end
  
  ans = lowestScore*population
  
   
  return ans
end

def calculate_score_for_tile(pop_map, tile,radius_y,radius_x)
  score = 0.0
  #determine cells to search
	if (tile[0][0]-radius_y)>= 0
		lower_y = tile[0][0]-radius_y
	else
		lower_y = 0
	end
	
	if (tile[0][0]+radius_y)<= (pop_map.length-1)
		upper_y = tile[0][0]+radius_y
	else
		upper_y = pop_map.length-1
	end
	
	if (tile[0][1]-radius_x)>= 0
		lower_x = tile[0][1]-radius_x
	else
		lower_x = 0
	end
	
	if (tile[0][1]+radius_x)<= (pop_map[0].length-1)
		upper_x = tile[0][1]+radius_x
	else
		upper_x = pop_map[0].length-1
	end
	#puts "Y: #{lower_y},#{upper_y}"
	#puts "X: #{lower_x},#{upper_x}"
	
  for y in lower_y..upper_y
    for x in lower_x..upper_x
      # current cell is y,x
      # 1. find nearest stop
      nearest_stop = get_nearest_pokestop(y, x, tile)
      #puts "y: #{y}"
      # 2. calculate score for current cell to nearest stop
      population = pop_map[y][x]  # population in current cell
      cell_score = calculate_score_for_tile_to_tile(y, x, nearest_stop, population) 
      score = score + cell_score
    end
  end
  return score
end

def calculate_score_for_area(coordinates_for_stop, tile,pop_map,cost_map)
  score = 0.0
  
	#Calculating score from distance
  for coor in 0...coordinates_for_stop.length
		y = coordinates_for_stop[coor][0]
		x = coordinates_for_stop[coor][1]
		
      population = pop_map[y][x]  # population in current cell
      cell_score = calculate_score_for_tile_in_area(y, x, tile, population) 
      score = score + cell_score
    
  end
  #calculating score from cost of stop
  cost_of_stop = cost_map[tile[0]][tile[1]]
  score = score - cost_of_stop
  return score
end

def calculate_score_for_tile_in_area(y, x, stop, pop)
 
  if pop == 0
    return 0
  end
  
  dist = distance(y, x, stop[0], stop[1])
  if dist == 0
		score=pop
	else
		score =  pop/dist
	end
  return score
end

def calculate_score_for_tile_to_tile(y, x, stop, pop)
 
  if pop == 0
    return 0
  end
  
  dist = distance(y, x, stop[0], stop[1])
  if dist == 0
		score=pop
	else
		score =  pop/dist
	end
  return score
end


def get_pokestops_with_stops(pop_map, number_of_stops, cost_map)
	# if number of stops == 1 then run this code else split the map
	if number_of_stops == 1
		
		answer = []
	  
	 
		#takes population density (score, as an argument)
		sorting = Hash.new #new hash for sorting scores
		
		#Determines search radi based on formula below, limiting the total search
		radius_y = pop_map.length/(number_of_stops)
		radius_x = pop_map[0].length/(number_of_stops)
		#Caps radius at 50
		radius_cap = 30
		if radius_y >= radius_cap
			radius_y = radius_cap
		end
		if radius_x >= radius_cap
			radius_x = radius_cap
		end	
		
		
		
		#limits the search more if the no. of poke stops is small
		
		margin = 0.9
		y_margin = pop_map.length*margin/2
		x_margin = pop_map[0].length*margin/2
		#puts "%margin: #{margin}"
		
		u_y_margin = pop_map.length - y_margin
		u_x_margin = pop_map[0].length - x_margin
		#puts "y_margin = #{y_margin}"
		#puts "u_y_margin = #{u_y_margin}"
		
		y_margin = y_margin.floor
		x_margin = x_margin.floor
		u_y_margin = u_y_margin.ceil
		u_x_margin = u_x_margin.ceil
		
		#puts "y_margin = #{y_margin}"
		#puts "u_y_margin = #{u_y_margin}"
		
		#starts the ranking
		for y in y_margin...u_y_margin
			for x in x_margin...u_x_margin
					tile = [[y,x]]
					sorting[[y,x]] = calculate_score_for_tile(pop_map,tile,radius_y,radius_x)
			end
		end
		
		# sorts the hash into an array (reversed as best score is best)
		# Example: "[0,1]" = 50,... ====> Array = [[[0,1],50],...]
		sorting = sorting.sort_by {|key,value|value}.reverse
		
		
		#assigns stops in sorting array into answer
		#Determines search radi based on formula below, limiting the total search
		radius_y = pop_map.length/(number_of_stops*2)+1
		radius_x = pop_map[0].length/(number_of_stops*2)+1
		
		
		
		
		#if number of stops == 1 just equate answer to first element in sorting
		if number_of_stops == 1
			stop = sorting[0][0]
			answer << stop
		else
			for i in 0...number_of_stops
			
				#first stop in answer
				if i == 0	
					stop = sorting[i][0]
					answer << stop
				else
					
					#initialize temp array to store cluster coordinates
					temp = []
					numbers_to_be_ignored =[]
					
					for z in 0...answer.length
					#find the coordinates in the first cluster
					#answer[0]
						
						# determine the other coordinates in the cluster
						if (answer[z][0]-radius_y)>= 0
							lower_y = answer[z][0]-radius_y
						else
							lower_y = 0
						end
						
						if (answer[z][0]+radius_y)<= (pop_map.length-1)
							upper_y = answer[z][0]+radius_y
						else
							upper_y = pop_map.length-1
						end
						
						if (answer[z][1]-radius_x)>= 0
							lower_x = answer[z][1]-radius_x
						else
							lower_x = 0
						end
						
						if (answer[z][1]+radius_x)<= (pop_map[0].length-1)
							upper_x = answer[z][1]+radius_x
						else
							upper_x = pop_map[0].length-1
						end
						
						
						#add coordinates to array
						for y in lower_y..upper_y
							for x in lower_x..upper_x
								temp << [y,x]
							end
						end
					end
					#gets rid of duplicates in the array
					temp = temp.uniq
					
					#runs through sorting to remove points within the same cluster
						for h in 0...temp.length
							for o in 0...sorting.length
								if sorting[o][0] == temp[h]
									
									numbers_to_be_ignored << o
									
								end
							end
						end
					
					#using numbers_to_be_ignored, congigures an array to decide on the node to use in sorting
					numbers_to_be_ignored.uniq
					numbers_to_be_used =[]
					for t in 0...sorting.length
							numbers_to_be_used << t
					end
					
					for l in 0...numbers_to_be_ignored.length
						del = numbers_to_be_ignored[l]
						numbers_to_be_used.delete(del)
					end
					
					num = 0 
					texx = numbers_to_be_used[num]
					#puts "Initial Num: #{texx}"
					
					if numbers_to_be_used[num] == nil
						#puts "Number to be used is 'nil'"
						stop = sorting [i][0]
						answer <<stop
					else
						#shift to the next number in numbers to be used if the number has been used in "answer"
						for j in 0...answer.length
							num_temp = numbers_to_be_used[num]
							if sorting[num_temp][0] == answer
								num = num + 1
							end
						end
						texxx = numbers_to_be_used[num]
						#puts "Latter Num: #{texxx} "
						#safeguard if the whole map is covered by the cluster
						if numbers_to_be_used[num] == nil
							stop = sorting[i][0]
							answer << stop
						else	
							num_temp = numbers_to_be_used[num]
							stop = sorting[num_temp][0]
							answer << stop
						end
					end
				end
			end
			
		end
	end
	if number_of_stops >= 2 
		#split map into number of stops
		answer = []
		
		#find y and x coordinates to split
		no_areas = 0
		y_areas = 1
		x_areas = 1
		count = 0
		max_y = pop_map.length
		max_x = pop_map[0].length
		
		
		while no_areas < number_of_stops*1.1
			
			if max_y > max_x
				if y_areas == x_areas
					y_areas = y_areas + 1
				else
					x_areas = x_areas + 1
				end
			else
				if x_areas == y_areas
					x_areas = x_areas +1
				else
					y_areas = y_areas + 1
				end
			end
			no_areas = y_areas*x_areas
		end
		
		
		#split
		y_area_length = 1.00*max_y/y_areas
		x_area_length = 1.00*max_x/x_areas
		
		area_y = 1
		area_x = 1
		area_count = 0
		area_coordinates = Array.new(no_areas)
		#find coordinates in each area in area_coordinates
		for y_part in 0...y_areas
			for x_part in 0...x_areas
				#form y and x upper and lower coordinates
				l_y_coordinates = (y_area_length*y_part).round
				
				u_y_coordinates = (y_area_length*(1+y_part)).round
				
				l_x_coordinates = (x_area_length*x_part).round
				
				u_x_coordinates = (x_area_length*(1+x_part)).round
				
				temp_coor = []
				for y in l_y_coordinates...u_y_coordinates
					for x in l_x_coordinates...u_x_coordinates
					temp_coor << [y,x]
					end
				end
				area_coordinates[area_count] = temp_coor
				area_count = area_count + 1
				
			end
		end
		#puts "#{area_coordinates}"
		
		#find the sum of each area
		area_scores = Hash.new
		for i in 0...no_areas
			temp = area_coordinates[i]
			temp_area_score = 0
			for z in 0...temp.length
				y = temp[z][0]
				x = temp[z][1]
				tile_score = pop_map[y][x]
				temp_area_score = tile_score + temp_area_score
			end
			area_scores[i]= temp_area_score
		end
		
		for i in 0...no_areas
			count = area_scores[i]
			count2 = area_coordinates[i].length
		end
		
		#sort the hash into an array with a decending order
		area_scores_array = area_scores.sort_by {|key,value|value}.reverse
		#puts "#{area_scores_array}"
		
		
		for i in 0...number_of_stops
			area_for_stop = area_scores_array[i][0]
			coordinates_for_stop = area_coordinates[area_for_stop]
			
			#create hash to sort for best tile in area
			sorting = Hash.new
			#search in coordinates area for the best spot
			
			for l in 0...coordinates_for_stop.length
				
				tile = coordinates_for_stop[l]
				
				#test = calculate_score_for_area(coordinates_for_stop,tile,pop_map)
				
				
				sorting[coordinates_for_stop[l]] = calculate_score_for_area(coordinates_for_stop, tile, pop_map,cost_map)
				
			end
			
			# sorts the hash into an array (reversed as best score is best)
			# Example: "[0,1]" = 50,... ====> Array = [[[0,1],50],...]
			sorting = sorting.sort_by {|key,value|value}.reverse
			temp = []
			temp << sorting[0][0]
			temp << area_for_stop
			answer << temp
		end
		
		
	end
	# answer in format | [y,x] (stop coor), (area_no)| last element are the area coordinates array 2nd last is x_areas
	answer << x_areas 
	answer << area_coordinates
	
	return answer

end