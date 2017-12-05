# p2a_main.rb
# Do not submit this file

# You may modify this file for testing purposes, 
# but your final p2a.rb must be able to run with the original p2a_main.rb.

load "p2a.rb"
load "p2a_utility.rb"
include Math

# (1) ----- get user input -----
puts
print "CSV for pop data (e.g. map1.csv)   :"
pop_map_file_name = gets.chomp
print "CSV for cost data (e.g. cost1a.csv) :"
cost_map_file_name = gets.chomp

# (2) ----- prepare data ------
# read from CSV
pop_map  = read_file("data/" + pop_map_file_name)
cost_map = read_file("data/" + cost_map_file_name)

# check if pop map is compatible with cost map
if pop_map.flatten.size != cost_map.flatten.size
  abort "Error: the pop map and cost map your selected are not compatible. They must have the same dimensions"
end

# make a clone of the original pop map. 
original_pop_map = Marshal.load(Marshal.dump(pop_map))
original_cost_map = Marshal.load(Marshal.dump(cost_map))

# (3) ----- run the test cases -----
puts "Invoking your get_pokestops method now using pop map (#{pop_map_file_name}) and cost map (#{cost_map_file_name})..."
startTime = Time.now
selected_stops = get_pokestops(pop_map, cost_map) # calling your method here!!!!
time_taken = Time.now - startTime
puts "Time taken: #{time_taken} seconds." # display time lapsed
puts 
  
# (4) ----- check correctness and quality of answer ------ 
if no_error(selected_stops, original_pop_map)
  puts "Your answer :"
  puts
	
  # check quality score here
  score = calculate_score_for_map(original_pop_map, original_cost_map, selected_stops, false)
  score = score.round
  puts
  puts "Your score : #{score}. (The lower the better.)"
end