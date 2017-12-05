# p1_utility.rb (v1.1)
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

# checks if answer is in this format: [[y1, x1],[y2, x2],[y3, x3]...].
# y1, y2... must be >0 and <= max_y
# x1, x2... must be >0 and <= max_x
def contains_only_valid_coordinates(answer, max_y, max_x)
  for i in 0...answer.length
    current_pair = answer[i]
    
    # check type
    if current_pair == nil or !current_pair.kind_of?(Array) or current_pair.length!=2
      # puts "Error: This coordinate pair is invalid :" + current_pair.to_s
      return false
    end
    
    # check 1st number (y)
    if !current_pair[0].kind_of?(Integer) or current_pair[0]<0 or current_pair[0]>max_y
      # puts "Error: This coordinate pair is invalid because of the 1st value (y) :" + current_pair.inspect
      return false
    end
    
    # check 2nd number (x)
    if !current_pair[1].kind_of?(Integer) or current_pair[1]<0 or current_pair[1]>max_x
      # puts "Error: This coordinate pair is invalid because of the 2nd value (x) :" + current_pair.inspect    
      return false
    end    
  end
  return true # all OK
end

# calculates distance between 2 points
def distance(y1, x1, y2, x2)
  return sqrt(((y1-y2).abs)**2 + ((x1-x2).abs)**2)
end

# determines and returns nearest pokestop of a particular cell
# stops: an array of coordinates in y,x format (e.g. [[0, 0],[5, 4],[1, 1]])
# returns the coordinates of nearest pokestop as an array: [y, x]
# if there are two nearest pokestop, this method may return either one.
def get_nearest_pokestop(y, x, stops) 
  # create clone of stops. we won't touch stops from here onwards
  temp = Marshal.load(Marshal.dump(stops))
  
  # insert distance, to get [y, x, dist] for each stop
  for i in 0...temp.length
    stop = temp[i]
    stop_y = stop[0]
    stop_x = stop[1]
    temp[i] << distance(stop_y, stop_x, y, x)
  end
  
  temp.sort_by!{|y, x, d| d}
  
  # puts "nearest stop for " + y.to_s + "," + x.to_s + " is " + (temp[0][0]).to_s + "," + (temp[0][1]).to_s  
  return [temp[0][0], temp[0][1]] 
end

# returns score using formula: 
# score = distance from cell (y,x) to stop * population at cell
def calculate_score_for_cell(y, x, stop, pop)
  #
  if pop == 0
    # puts "for (" + y.to_s + "," + x.to_s + ")"
    # puts "pop   :" + pop.to_s
    # puts "dist  : n/a"
    # puts "score : 0"  
    return 0
  end
  
  dist = distance(y, x, stop[0], stop[1])
  score = dist * pop
  
  #puts "for (" + y.to_s + "," + x.to_s + ")"
  #puts "pop   :" + pop.to_s
  #puts "dist  :" + dist.to_s  
  #puts "score :" + score.to_s
  #puts
  
  return score
end

# returns score of selected stops based on pop map
def calculate_score_for_map(pop_map, stops)
  score = 0.0

  for y in 0...pop_map.length
    for x in 0...pop_map[0].length
      # current cell is y,x
      # 1. find nearest stop
      nearest_stop = get_nearest_pokestop(y, x, stops)
           
      # 2. calculate score for current cell to nearest stop
      population = pop_map[y][x]  # population in current cell
      cell_score = calculate_score_for_cell(y, x, nearest_stop, population)
      
      score = score + cell_score
    end
  end
  
  return score
end

# checks if there is a syntax error in selected_stops
# if so, print out error message, and return false
# if selected_stops is fine, return true
def no_error(selected_stops, pop_map, number_of_stops)
  if selected_stops == nil
    # error
    puts "Your method returned :" + selected_stops.to_s
    puts "Error : your method returned nil. It should return a 2D array of integers."
    return false
  elsif selected_stops.count != number_of_stops
    puts "Your method returned #{selected_stops.count} stops. We expected #{number_of_stops} stops instead."
    puts "Error : your method returned the wrong number of stops."
    return false  
  elsif !selected_stops.kind_of?(Array)
    # error
    puts "Your method returned :" + selected_stops.to_s
    puts "Error : your method returned something other than an array. It should return a 2D array of integers"
    return false
  elsif selected_stops.empty?
    # error
    puts "Your method returned :" + selected_stops.inspect
    puts "Error : your method returned an empty array. There must be at least 1 pair of coordinates."
    return false
  elsif !contains_only_valid_coordinates(selected_stops, pop_map.length-1, pop_map[0].length-1)
    # error
    puts "Your method returned :" + selected_stops.inspect
    puts "Error : your method returned an array in an invalid or unrecognized format."
    return false
  else
    return true
  end
end
  
# print out nicely the list of pokestops in stops
def print_nicely(stops)
  for i in 0...stops.length
    puts "\t" + (i+1).to_s + ": " + stops[i].inspect
  end
end

