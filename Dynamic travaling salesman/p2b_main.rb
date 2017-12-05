# p2b_main.rb 
# Do not submit this file

# You may modify this file for testing purposes, 
# but your final p2b.rb must be able to run with the original p2b_main.rb.

load "p2b.rb"
load "p2b_utility.rb"
include Math

# (1) ----- get user input for test case parameters -----
puts
print "CSV with pokemon map data (e.g. pmap0.csv) :"  # pmap
pmap_file_name = gets.chomp
if pmap_file_name.length == 0
  pmap_file_name = "pmap0.csv"
end

print "CSV with corresponding tws data (e.g. pmap0_start.csv) :" # tws
tws_file_name = gets.chomp
if tws_file_name.length == 0
  tws_file_name = "pmap0_start.csv"
end

print "CSV with corresponding twe data (e.g. pmap0_end.csv) :" # twe
twe_file_name = gets.chomp
if twe_file_name.length == 0
  twe_file_name = "pmap0_end.csv"
end

repeat = true  # curr_pos
while repeat
  print "Enter current position (y,x) (e.g. 0, 4):"   
  input = gets.chomp
  pos_of_comma = input.index(",")
  if pos_of_comma != nil
    repeat = false
  else
    puts "Error: Incorrect format for current position. There should be a comma in your input."
  end
end  
y = input[0...pos_of_comma].strip.to_i
x = input[pos_of_comma+1...input.length].strip.to_i
curr_pos = [y, x]
puts "curr_pos(y,x) entered is #{curr_pos.inspect}"

print "Enter end time (e.g. 15):"   # end_time
end_time = gets.chomp.to_i
puts "end_time entered is #{end_time}"
puts

# (2) ----- prepare data ------
# read from file_name and store in pmap
pmap = read_file("data/" + pmap_file_name)
original_pmap = Marshal.load(Marshal.dump(pmap)) # clone

tws = read_file("data/" + tws_file_name)
original_tws = Marshal.load(Marshal.dump(tws)) # clone

twe = read_file("data/" + twe_file_name)
original_twe = Marshal.load(Marshal.dump(twe)) # clone

# (3) ----- run the test cases -----
puts
puts "Invoking your get_route method now using the following parameters:"
puts " - curr_pos       : #{curr_pos.inspect}"
puts " - end_time       : #{end_time}"
puts " - pmap read from : #{pmap_file_name}"
puts " - tws read from  : #{tws_file_name}"
puts " - twe read from  : #{twe_file_name}"
puts

startTime = Time.now
route = get_route(curr_pos, end_time, pmap, tws, twe) # calling your method here!!!!
time_taken = Time.now - startTime
  
puts "Time taken: #{time_taken} seconds." # display time lapsed
puts 
  
# (4) ----- check correctness and quality of answer ------ 
# check for errors in selected_stops
score = "error"

if no_error(route, pmap, curr_pos)
  puts "Your answer :"
  print_nicely_route(route)
    
  # check quality score here
  score_time = get_score_and_time_taken_for_route(route, original_pmap, original_tws, original_twe, true)
  route_score = score_time[0].round
  route_time = score_time[1].round(3)
  puts
  puts "Reminder: For this assignment, a higher quality score (for the same map and start/end time windows) is a better score.\n\n"
  puts
  puts "Your quality score (total CP collected): #{route_score}"
  print "Time taken by your route               : #{route_time}"
  
  # check if route time exceeds end_time
  if route_time > end_time
    puts " Error: Route exceeds end time (t=#{end_time}) specified by player!"
  else
    puts " OK! Player will be back by end time (t=#{end_time})."
  end
end
