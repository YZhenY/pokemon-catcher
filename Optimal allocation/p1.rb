# Name: Yong Zhen Yu
# Section: G1

# project 1

# arguments: 
#   pop_map: a 2D array of integers, representing the population density at each cell
#            e.g. for map0, pop_map will be:
#                 [[2,5,5,1,3], [8,4,4,0,2], [1,5,2,0,6]]
#   number_of_stops: an integer, representing the number of pokestops this method is expected 
#                    to come up with and return. You can assume that this is always a positive  
#                    number, which is also smaller than the total number of cells in pop_map.
# returns: the coordinates of the recommended pokestops as a 2D array. 
#          e.g. this method may return [[1,0], [0,2] and [2,4]] to represent the (y,x) coordinates 
#          of three selected stops (assuming number_of_stops is 3).
#          Do ensure that:
#            - each returned coordinate is valid (i.e. there is such a cell in the pop_map), and
#            - the length of the returned array must match number_of_stops 
#              (i.e. there should be number_of_stops pair of coorindates).


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

def calculate_score_for_area(coordinates_for_stop, tile,pop_map)
  score = 0.0
  
	
  for coor in 0...coordinates_for_stop.length
		y = coordinates_for_stop[coor][0]
		x = coordinates_for_stop[coor][1]
		
      population = pop_map[y][x]  # population in current cell
      cell_score = calculate_score_for_tile_in_area(y, x, tile, population) 
      score = score + cell_score
    
  end
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


def get_pokestops(pop_map, number_of_stops)
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
				
				test = calculate_score_for_area(coordinates_for_stop,tile,pop_map)
				
				
				sorting[coordinates_for_stop[l]] = calculate_score_for_area(coordinates_for_stop, tile, pop_map)
				
			end
			
			# sorts the hash into an array (reversed as best score is best)
			# Example: "[0,1]" = 50,... ====> Array = [[[0,1],50],...]
			sorting = sorting.sort_by {|key,value|value}.reverse
			answer<< sorting[0][0]
		end
		
		
	end
	return answer

end
