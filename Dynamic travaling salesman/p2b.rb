# Team ID: G1T6

# project 2b

# arguments: 
#   curr_pos : 1D array of integers. Current player's position [y, x]
#   end_time : integer. Time that player must get back to curr_pos by
#   pmap     : 2D array of integers. The Combat Points (CP) of the Pokemons at each position is in this array. A value of -1 means that there is no Pokemon there.
#   tws      : (time window start) 2D array of integers. The "starting time" when the Pokemon at each position will appear.
#   twe      : (time window end)   2D array of integers. The "ending time" when the Pokemon at each position will disappear. You can assume that the time_window_end will always be the same or later (bigger) than the corresponding values in tws.              
#
# returns: a 2D array showing all the positions on the route, and the waiting time (if any) at each position.
#          e.g. [[0, 4, 0], [2, 3, 0], [0, 3, 0], [0, 2, 2.7], [0, 4, 0]]
#       Do ensure that:
#       - the first element in the returned array is curr_pos + waiting time. ([0, 4] is the starting/ending position in the e.g. above)
#       - the last element in the returned array is curr_pos + waiting time.
#       - the coordinates must be integers. The waiting time can be a float (e.g. 2.7).


def get_route(curr_pos, end_time, pmap, tws, twe)  
    ans = []
    starting_tuple = curr_pos << 0 # 0 is the waiting time
    ans << starting_tuple # [y, x, time unit]
    
	
	
    max_y = pmap.length - 1  
    max_x = pmap[0].length - 1
    
    highest_score = 0.0
    
	time_for_score = 0.0
	time_for_get_ans = 0.0
	
	temp = -1
	temp1 = 0
	for y in 0..max_y
		temp1 = pmap[y].count(temp)+ temp1 
	end
	
	no_of_pokemon = (pmap.length*pmap[0].length - temp1)
	
	number_of_loops =  0.7541*Math.log(no_of_pokemon,E) + 0.9829
	

	
	
    for h in 0...number_of_loops
        pmap1 = Marshal.load(Marshal.dump(pmap))
        tws1 = Marshal.load(Marshal.dump(tws))
        twe1 = Marshal.load(Marshal.dump(twe))
		
        time_taken = Time.now
        sortedArrayByRatioDistStart1 = []
        ans1 = []
        ans1 = getArrayResultsWithStartingPokemon(starting_tuple, pmap1, tws1, twe1, sortedArrayByRatioDistStart1, end_time, h)
		time_for_get_ans = Time.now - time_taken + time_for_get_ans
		
		pmap1 = Marshal.load(Marshal.dump(pmap))
        tws1 = Marshal.load(Marshal.dump(tws))
        twe1 = Marshal.load(Marshal.dump(twe))
		
		time_taken = Time.now
        score_time1 = get_score(ans1, pmap1, tws1, twe1)
        route_score1 = score_time1[0].round
        route_time1 = score_time1[1].round(3)
        time_for_score = Time.now - time_taken + time_for_score
		
        if highest_score <= route_score1
            final_ans = ans1
            highest_score = route_score1
        end
		
		
    end
    

    return final_ans
end

def getArrayResultsWithStartingPokemon(starting_tuple, pmap1, tws1, twe1, sortedArrayByRatioDistStart, end_time, intStart)
    ans = []
    ans << starting_tuple
    current_tuple = starting_tuple
    currentTime = 0 # after deciding on the pokemon
    routeCompleted = false
    
    averageTimeWindow = 0.0
    averageTimeWindow = getAverageTimeWindow(tws1, twe1)
    
    scaleWaitTime = 0.0
    scaleWaitTime = averageTimeWindow/8
	count = 0 
	
    while !routeCompleted
        # change current pokemon cp, start time and end time to -1
        pmap1[current_tuple[0]][current_tuple[1]] = -1
        tws1[current_tuple[0]][current_tuple[1]] = -1
        twe1[current_tuple[0]][current_tuple[1]] = -1
        
		
        # array contains cpDistRatio, distance, startTime, endTime, pokemon index, cp, waiting time
        # array is sorted by ratio first, distance, CP, then time start
        sortedArrayByRatioDistStart = getRatioDistStartEndIndex(pmap1, current_tuple, tws1, twe1, currentTime, starting_tuple, end_time)
        
        # if array is empty, means no other pokemons to go that can make it back on time
        # time to head home
		
		# if count > 30 
			# break
			# puts "Loop broken"
		# end
		count += 1
			
        if sortedArrayByRatioDistStart.empty?         
            # this is added only for checking pokemons that are missed out (can remove if not using)
            # currentTime += distance(starting_tuple[0], starting_tuple[1], ans[[ans.length-1][0]], ans[[ans.length-1][1]])
            
            ans << starting_tuple
            routeCompleted = true
            break
        else
            pokemonIndex = []
            currentTimeWThisPokemon = 0.0
            
            # for when all waiting time in array is more than 3
            minWaitingTime = 0.0
            minPokemonDist = 0.0
			#puts "count -= #{count}"
			if count == 1
				#puts "minWaitingTime = #{sortedArrayByRatioDistStart} "
				minWaitingTime = sortedArrayByRatioDistStart[intStart][6]
				pokemonIndexWithMinWaitTime = []
				pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[intStart][4][0]
				pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[intStart][4][1]
				pokemonIndexWithMinWaitTime << minWaitingTime
				minPokemonDist = sortedArrayByRatioDistStart[intStart][1]
			else
				minWaitingTime = sortedArrayByRatioDistStart[0][6]
				pokemonIndexWithMinWaitTime = []
				pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[0][4][0]
				pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[0][4][1]
				pokemonIndexWithMinWaitTime << minWaitingTime
				minPokemonDist = sortedArrayByRatioDistStart[0][1]
			end
			
			
            
            # loop through array to get a pokemon that requires waiting time between 0 and 3 
            (0..sortedArrayByRatioDistStart.length-1).step(1) do |i|
                # there are pokemons that can be added
                pokemonDetails = []
                if count == 1
                    pokemonDetails = sortedArrayByRatioDistStart[intStart]
                    i = intStart
                else 
                    pokemonDetails = sortedArrayByRatioDistStart[i]
                end
                
                pokemonDistance = pokemonDetails[1]
                pokemonStartTime = pokemonDetails[2]
                pokemonEndTime = pokemonDetails[3]
                pokemonWaitingTime = pokemonDetails[6]    
    
                # get pokemon with minimum waiting time just in case all pokemons have waiting time more than 3
                if pokemonWaitingTime < minWaitingTime
                    minWaitingTime = pokemonWaitingTime
                    pokemonIndexWithMinWaitTime = []
                    pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[i][4][0]
                    pokemonIndexWithMinWaitTime << sortedArrayByRatioDistStart[i][4][1]
                    pokemonIndexWithMinWaitTime << minWaitingTime
                    minPokemonDist = pokemonDistance
                end
                
                # add pokemon to list if there is no wait time or wait time less than scaled max wait time
                if pokemonWaitingTime >=0 && pokemonWaitingTime <= scaleWaitTime
                    pokemonIndex << pokemonDetails[4][0]
                    pokemonIndex << pokemonDetails[4][1]
                    pokemonIndex << pokemonWaitingTime
                    ans << pokemonIndex
                    
                    pmap1[pokemonDetails[4][0]][pokemonDetails[4][1]] = -1
                    tws1[pokemonDetails[4][0]][pokemonDetails[4][1]] = -1
                    twe1[pokemonDetails[4][0]][pokemonDetails[4][1]] = -1
                    
                    current_tuple = pokemonDetails[4]
                    currentTime += pokemonDistance
                    break
                end
                
                if i == sortedArrayByRatioDistStart.length-1
                    ans << pokemonIndexWithMinWaitTime
                    
                    pmap1[pokemonIndexWithMinWaitTime[0]][pokemonIndexWithMinWaitTime[1]] = -1
                    tws1[pokemonIndexWithMinWaitTime[0]][pokemonIndexWithMinWaitTime[1]] = -1
                    twe1[pokemonIndexWithMinWaitTime[0]][pokemonIndexWithMinWaitTime[1]] = -1
                    
                    current_tuple = [pokemonIndexWithMinWaitTime[0],pokemonIndexWithMinWaitTime[1]]
                    currentTime += minPokemonDist
                    break
                end
				
            end
        end
    end
    return ans
end

def getRatioDistStartEndIndex(pmap, currentCell, tws, twe, currentTime, starting_tuple, end_time)
    # method to get ratio of cp/(distance + waiting time)
    # before adding this cell into the results aarray
    # check that by adding this pokemon into the array, still able to go back home without exceeding the time

    max_y = pmap.length - 1  
    max_x = pmap[0].length - 1
    
    # Create arrray that will store cp to (dist + waiting time) ratio, distance, start time, end time, index of pokemon, cp
    arrWithCPDistStartEndPos = []
    cp = 0.0
    distance = 0.0    
    
    for y in 0..max_y
        for x in 0..max_x
            cp = pmap[y][x]
            
            #distance from current cell
            distance = distance(currentCell[0],currentCell[1],y,x)
            
            timeWhenReachPokemon = 0.0
            waitingTime = 0.0
            timeReached = 0.0
            
            timeWhenReachPokemon = currentTime + distance
            
            # only include pokemon if pokemon exists and time reached is before pokemon's end time
            if pmap[y][x] > 0 && timeWhenReachPokemon <= twe[y][x]
            
                # waiting time = start time - time reached
                waitingTime = tws[y][x] - timeWhenReachPokemon
                
                if waitingTime < 0
                    waitingTime = 0
                end
                
                timeToHome = distance(starting_tuple[0], starting_tuple[1], y ,x)
                timeReached = timeWhenReachPokemon + waitingTime
				
				# check if there will be enough time to go home
                if checkIfEnoughTimeToGoHome(timeReached, timeToHome, end_time)
				
					if currentTime >= 0.5*end_time
						cpDistRatio = cp/(distance + waitingTime + timeToHome)
					else
						cpDistRatio = cp/(distance + waitingTime)
					end
					
                    arrWithCPDistStartEndPos << [cpDistRatio, distance(currentCell[0],currentCell[1],y,x), tws[y][x], twe[y][x], [y,x], cp, waitingTime]
                end
            end
        end
    end

    # sort array by ratio, distance, CP, start time
    return arrWithCPDistStartEndPos.sort_by! {|a| [ -a[0], a[1], a[5], a[2]]}    
end

def checkIfEnoughTimeToGoHome(timeReached, timeToHome, end_time)
	
    if timeReached + timeToHome <= end_time
        return true
    end
    return false
end

def getAverageTimeWindow(tws, twe)
    totalTimeWindow = 0.0
    totalNumberPokemon = 0.0
    average = 0.0
    
    max_y = tws.length - 1  
    max_x = tws[0].length - 1
    
    for y in 0..max_y
        for x in 0..max_x
            if tws[y][x] >= 0
                totalTimeWindow += twe[y][x] - tws[y][x]
                totalNumberPokemon += 1
            end
        end  
    end
    
    average = totalTimeWindow/totalNumberPokemon
    
    return average
end

def get_score(route, pokemon_map, time_window_start, time_window_end)
  total_cp = 0  # cummulative CP
  curr_time = 0.0
  
  for i in 0...route.length
    if i == 0
      y_prev = route[i][0]
      x_prev = route[i][1]
    else 
      y_prev = route[i-1][0]
      x_prev = route[i-1][1]
    end
    
    y_curr = route[i][0]
    x_curr = route[i][1]
    dist_to_curr = distance(y_prev, x_prev, y_curr, x_curr)
    curr_time += dist_to_curr    
   
    wait_time = route[i][2]
    depart_time = curr_time + wait_time
   
 
    
    # update total_cp if there is a pokemon there
    total_cp += get_cp2(y_curr, x_curr, curr_time, depart_time, pokemon_map, time_window_start, time_window_end)
    
    # update curr_time (applies if there is wait time)
    curr_time = depart_time
  end
  return [total_cp, curr_time.round(3)]
end

def get_cp2(y_curr, x_curr, curr_time, depart_time, pokemon_map, time_window_start, time_window_end)
  # is there a pokemon here? 
  cp = pokemon_map[y_curr][x_curr]

  if  cp <= 0
    # no pokemons here
    
    return 0
  end
    
  # yes, pokemon here  
  time_pokemon_appears    = time_window_start[y_curr][x_curr]
  time_pokemon_disappears = time_window_end[y_curr][x_curr]
      
      
  # do you get to see the pokemon? yes, in 1 of 3 scenarios
  # 1st scenario: curr_time falls between time_pokemon_appears & time_pokemon_disappears
  # 2nd scenario: curr_time falls between time_pokemon_appears & time_pokemon_disappears
  # 3rd scenario: curr_time is before time_pokemon_appears & depart_time is after time_pokemon_disappears
  if (curr_time >= time_pokemon_appears and curr_time <= time_pokemon_disappears) or 
     (depart_time >= time_pokemon_appears and depart_time <= time_pokemon_disappears) or
     (curr_time <= time_pokemon_appears and depart_time >= time_pokemon_disappears)
    
    pokemon_map[y_curr][x_curr] = -1 # this will prevent a "recapture" later
    return cp
  else
    
    return 0
  end
end