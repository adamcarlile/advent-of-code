require 'pry'

results = {
  increased: 0,
  decreased: 0
}

data = File.read("data.txt").split("\n").map(&:to_i)

data.each_cons(2) do |a, b| 
  results[:increased] += 1 if (a <=> b).negative?
  results[:decreased] += 1 if (a <=> b).positive?
end

puts "\n====PART 1====\n"
puts "Total increase: #{results[:increased]}"

results = {
  increased: 0,
  decreased: 0
}

data.each_cons(3).map(&:sum).each_cons(2) do |a, b|
  results[:increased] += 1 if (a <=> b).negative?
  results[:decreased] += 1 if (a <=> b).positive?
end

puts "\n====PART 2====\n"
puts "Total increase: #{results[:increased]}"