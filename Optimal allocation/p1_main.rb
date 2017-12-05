# p1_main.rb (v1.1)
# Do not submit this file

# You may modify this file for testing purposes, 
# but your final p1.rb must be able to run with the original p1_main.rb.

load "p1.rb"
load "p1_utility.rb"
include Math

# (1) ----- get user input -----
puts
print "CSV that contains pop data (e.g. map1.csv)  :"
map_file_name = gets.chomp
puts "We will call your method multiple times using different number of pokestops as inputs."
print "No. of pokestops (start):"
no_of_stops_start = gets.to_i
if no_of_stops_start <= 0 # check for error in no_of_stops_start
  abort "Error: This should be a positive number."
end
print "No. of pokestops (end)  :"
no_of_stops_end = gets.to_i
if no_of_stops_end < no_of_stops_start or no_of_stops_start < 0 # check for error
  abort "Error: This number cannot be smaller than No. of pokestops (start)"
end

# (2) ----- prepare data ------
# read from file_name and store in pop_map
pop_map = read_file("data/" + map_file_name)

# make a clone of the original pop map. 
original_pop_map = Marshal.load(Marshal.dump(pop_map))

# (3) ----- run the test cases -----
puts "Invoking your get_pokestops method now using map from #{map_file_name}"

# repeat for (no_of_stops_end - no_of_stops_start) number of times
counter = 1
statement = ""
for number_of_stops in no_of_stops_start..no_of_stops_end

  puts "----------------------------------"
  puts "Test case #{counter} : number_of_stops is #{number_of_stops}"
  counter += 1
  
  startTime = Time.now
  selected_stops = get_pokestops(pop_map, number_of_stops) # calling your method here!!!!
  time_taken = Time.now - startTime
  
  puts "Time taken: #{time_taken} seconds." # display time lapsed
  puts 
  
  # (4) ----- check correctness and quality of answer ------ 
  # check for errors in selected_stops
  score = "error"
  if no_error(selected_stops, original_pop_map, number_of_stops)
    puts "Your answer :"
    print_nicely(selected_stops)
    
    # check quality score here
    score = calculate_score_for_map(original_pop_map, selected_stops)
    score = score.round
    puts
    puts "Your score : #{score}"
  end
  
  # prepare summary for printing later
  statement += "\t#{number_of_stops}\t#{score.to_s}\t#{time_taken}\n"
  
  # just in case your method modifies pop_map. Restores it to its original value for next loop
  pop_map = Marshal.load(Marshal.dump(original_pop_map))  
end

# (5) ----- print summary, yada yada ----- 
puts "----------------------------------"
#puts "\nReminder: For this assignment, a lower score (for the same number of pokestops) is a better score.\n\n"
puts "Summary:"
puts "\tstops\tscore\ttime taken"
puts statement
