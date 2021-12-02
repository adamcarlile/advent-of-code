require 'pry'

data = File.read("data.txt").split("\n").map {|x| x.split(' ') }

results = {
  depth: 0,
  position: 0,
  aim: 0
}

operators_part_1 = {
  "forward" => Proc.new() { |value| results[:position] += value },
  "down" => Proc.new() { |value| results[:depth] += value },
  "up" => Proc.new() { |value| results[:depth] -= value }
}

data.each { |tuple| operators_part_1[tuple[0]].call(tuple[1].to_i) }

puts "\n====PART 1====\n"
puts "Depth: #{results[:depth]}"
puts "Position: #{results[:position]}"
puts "Depth x Position = #{results[:depth]*results[:position]}"

results = {
  depth: 0,
  position: 0,
  aim: 0
}

operators_part_2 = {
  "forward" => Proc.new() { |value| results[:position] += value; results[:depth] += (results[:aim]*value) },
  "down" => Proc.new() { |value| results[:aim] += value },
  "up" => Proc.new() { |value| results[:aim] -= value }
}

data.each { |tuple| operators_part_2[tuple[0]].call(tuple[1].to_i) }

puts "\n====PART 2====\n"
puts "Depth: #{results[:depth]}"
puts "Position: #{results[:position]}"
puts "Aim: #{results[:aim]}"
puts "Depth x Position = #{results[:depth]*results[:position]}"