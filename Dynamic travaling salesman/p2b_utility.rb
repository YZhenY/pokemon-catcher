# p2_utility.rb
# Do not submit this file
# Do not modify this file as well. 

# Ensure that this file is in the same folder as p1_main.rb


# reads a CSV file and returns a 2D array of integers - each line in the CSV file is the 1st level array
def read_file(file)
	lines = IO.readlines(file)
	if lines == nil
    return nil
  end

  a = [] 
	for i in 0 .. lines.length-1
		current_line = lines[i].sub("\n","")
    a << current_line.split(",").map{ |x| x.to_i }
  end
	return a
end

# checks if answer is in this format: [[y1, x1, wait1],[y2, x2, wait2],[y3, x3, wait3]...].
# y1, y2... must be >0 and <= max_y
# x1, x2... must be >0 and <= max_x
# wait1, wait2... must be integers or floats, and >=0
def valid_format?(route, max_y, max_x)
  for i in 0...route.length
    current_tuple = route[i]
    
    # check type
    if current_tuple == nil or !current_tuple.kind_of?(Array) or current_tuple.length!=3
      puts "Error: This tuple is invalid : #{current_tuple} .It should be an array with 3 elements: [y, x, waiting_time]"
      return false
    end
    
    # check 1st number (y)
    y = current_tuple[0]
    if !y.kind_of?(Integer) or y<0 or y>max_y
      puts "Error: This tuple is invalid because of the 1st value (y) :" + current_tuple.inspect
      return false
    end
    
    # check 2nd number (x)
    x = current_tuple[1]
    if !x.kind_of?(Integer) or x<0 or x>max_x
      puts "Error: This tuple is invalid because of the 2nd value (x) :" + current_tuple.inspect    
      return false
    end    
    
    # check 3rd number (wait_time), must be integer or float, and >=0
    wait_time = current_tuple[2]
    if !wait_time.kind_of?(Float) and !wait_time.kind_of?(Integer)
      puts "Error: This tuple is invalid because of the 3rd value (wait time) :" + current_tuple.inspect    
      return false
    elsif wait_time < 0
      puts "Error: This tuple is invalid because one of the 3rd value (wait time) is negative :" + current_tuple.inspect    
      return false    
    end
  end
  return true # all OK
end

# calculates distance between 2 points
def distance(y1, x1, y2, x2)
  return sqrt(((y1-y2).abs)**2 + ((x1-x2).abs)**2)
end

# checks if there is an error in route based on pokemon_map
# checks if all points in route is within the map and other validation checks
# if so, print out error message, and return false
# if route is fine, return true
def no_error(route, pokemon_map, current_pos)
  if route == nil
    # error
    puts "Your method returned :" + route.to_s
    puts "Error: your method returned nil. It should return a 2D array."
    return false
  elsif !route.kind_of?(Array)
    # error
    puts "Your method returned :" + route.to_s
    puts "Error: your method returned something other than an array. It should return a 2D array"
    return false
  elsif route.count < 2
    # error
    puts "Your method returned #{route.count} tuples. There should be at least 2 tuples in your route."
    puts "Error: your method returned the wrong number of tuples."
    return false  
  elsif route.first[0] != current_pos[0] or route.first[1] != current_pos[1] or route.last[0] != current_pos[0] or route.last[1] != current_pos[1] 
    # error
    puts "Your method returned: #{route.inspect}"
    puts "Error: the first and last tuples should match current_pos. current_pos is #{current_pos.inspect}. So the first and last tuples should be [#{current_pos[0]}, #{current_pos[0]}, waiting_time]."
    return false
  elsif !valid_format?(route, pokemon_map.length-1, pokemon_map[0].length-1)
    # error
    puts "Your method returned :" + route.inspect
    puts "Error : your method returned an array in an invalid or unrecognized format. Check that:"
    puts "  (1) each element in your returned array must contain 3 elements: [y, x, waiting time]"
    puts "  (2) the coordinates at every tuple are all within the map"
    puts "  (3) the waiting time at every tuple is >=0"
    return false
  else
    return true
  end
end
  
# print out the route in a nice format
def print_nicely_route(route)
  puts
  for i in 0...route.length
    if i == 0
      print "START"
    elsif i == route.length-1
      print "END"
    end
    puts "\t #{i+1}: [#{route[i][0]}, #{route[i][1]}] \tWait: #{route[i][2]}"
  end
  puts
end

# print out the pokemon_map or time maps in a nice format
def print_nicely_map(map)
  puts
  for i in 0...map.length
    for j in 0...map[i].length
      print "\t#{map[i][j]}"
    end
    puts
  end
  puts
end

# returns the CP obtained at this position (0 if no CP is obtained)
# the pokemon_map, time_window_start and time_window_end arrays are taken into consideration
# assumption here is that [y_curr,x_curr] exists on pokemon_map. Otherwise there will be an error
# 
# if print_msg is true, the method will print out useful messages to show how the score and time taken are calculated
def get_cp(y_curr, x_curr, curr_time, depart_time, pokemon_map, time_window_start, time_window_end, print_msg = false)
  # is there a pokemon here? 
  cp = pokemon_map[y_curr][x_curr]

  if  cp <= 0
    # no pokemons here
    puts "  no pokemon here" if print_msg
    return 0
  end
    
  # yes, pokemon here  
  time_pokemon_appears    = time_window_start[y_curr][x_curr]
  time_pokemon_disappears = time_window_end[y_curr][x_curr]
      
  if print_msg # printing
    puts "  pokemon with CP #{cp} at this pos"
    puts "  time pokemon appears    :#{time_pokemon_appears}"
    puts "  time pokemon disappears :#{time_pokemon_disappears}"
  end
      
  # do you get to see the pokemon? yes, in 1 of 3 scenarios
  # 1st scenario: curr_time falls between time_pokemon_appears & time_pokemon_disappears
  # 2nd scenario: curr_time falls between time_pokemon_appears & time_pokemon_disappears
  # 3rd scenario: curr_time is before time_pokemon_appears & depart_time is after time_pokemon_disappears
  if (curr_time >= time_pokemon_appears and curr_time <= time_pokemon_disappears) or 
     (depart_time >= time_pokemon_appears and depart_time <= time_pokemon_disappears) or
     (curr_time <= time_pokemon_appears and depart_time >= time_pokemon_disappears)
    puts "  you got the pokemon! CP :#{cp}" if print_msg # printing
    pokemon_map[y_curr][x_curr] = -1 # this will prevent a "recapture" later
    return cp
  else
    # you missed the pokemon
    puts "  you missed the pokemon" if print_msg # printing
    return 0
  end
end

# returns a 1D array [score, time_taken] using the route
# prints an error message and returns nil if the route contains invalid coordinates
# does not check if route starts and ends at current_position
#
# if print_msg is true, the method will print out useful messages to show how the score and time taken are calculated
def get_score_and_time_taken_for_route(route, pokemon_map, time_window_start, time_window_end, print_msg = false)
  total_cp = 0  # cummulative CP
  curr_time = 0.0
  
  if print_msg # printing
    puts
    puts "Your journey :"
  end
  
  # for each position
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
    
    if print_msg # printing
      puts "#{i} -----------------------------------"
      puts "  curr pos         : [#{y_curr}, #{x_curr}]"
      puts "  dist to curr pos : %0.3f" %dist_to_curr
      puts "  curr time        : %0.3f" %curr_time
      puts "  wait time        : %0.3f" %wait_time
      puts "  depart time      : %0.3f" %depart_time
      puts
    end
    
    # update total_cp if there is a pokemon there
    total_cp += get_cp(y_curr, x_curr, curr_time, depart_time, pokemon_map, time_window_start, time_window_end, print_msg)
    
    # update curr_time (applies if there is wait time)
    curr_time = depart_time
    
    if print_msg # printing
      puts "  new curr_time: %0.3f" %curr_time 
      puts "  curr total CP :#{total_cp}"
    end
  end
  
  if print_msg # printing
    puts "Summary -----------------------------"
    puts "  Total CP of all Pokemons collected: #{total_cp}"
    puts "  Time taken: #{curr_time.round(3)}"
  end
  
  return [total_cp, curr_time.round(3)]
end