require 'pry'

results_1 = {
  increased: 0,
  decreased: 0
}

data = File.read("data.txt").split("\n").map(&:to_i)

data.each_cons(2) do |a, b| 
  results_1[:increased] += 1 if (a <=> b).negative?
  results_1[:decreased] += 1 if (a <=> b).positive?
end

puts "Total increase: #{results_1[:increased]}"

results_2 = {
  increased: 0,
  decreased: 0
}

data.each_cons(3).map(&:sum).each_cons(2) do |a, b|
  results_2[:increased] += 1 if (a <=> b).negative?
  results_2[:decreased] += 1 if (a <=> b).positive?
end

puts "Total increase: #{results_2[:increased]}"