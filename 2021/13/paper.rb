data = File.open("data.txt").read.split("\n\n")
marked = data[0].split("\n").map{_1.split(",").map(&:to_i)}
folds = data[1].split("\n").map{_1.gsub("fold along ", "").split("=")}

folds.each_with_index do |fold, i|
  axis, loc = fold
  if axis == "x"
    marked = marked.map{_1.first > loc.to_i ? [2 * loc.to_i - _1.first, _1.last] : _1}.uniq
  else
    marked = marked.map{_1.last > loc.to_i ? [_1.first, 2 * loc.to_i - _1.last] : _1}.uniq
  end
  puts "Part 1: #{marked.count}" if i == 0
end
output = []
[*0..marked.map(&:last).max].each do |y|
  [*0..marked.map(&:first).max].each do |x|
    output << (marked.include?([x, y]) ? "#" : " ")
  end
  output << "\n"
end

puts output.join