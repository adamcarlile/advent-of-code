require 'pry'
require 'matrix'
data = File.read("data.txt").split("\n").map {|x| x.split('').map(&:to_i)}

matrix = Matrix.rows(data)

hash = {}
matrix.column_vectors.each_with_index do |vector, index|
  hash[index] = vector.group_by(&:to_i).transform_values(&:length)
end

gamma = hash.map {|k, v| v.key(v.values.max) }.join('').to_i(2)
epsilon = hash.map {|k, v| v.key(v.values.min) }.join('').to_i(2)

puts "Gamma: #{gamma}"
puts "Epsilon: #{epsilon}"
puts "Gamme x Epsilon: #{gamma * epsilon}"

data = File.read("data.txt").each_line.map(&:chomp).map(&:chars)

bitcount = data.first.count

minbits = data.dup
maxbits = data.dup

transposed = data.transpose

a1 = []

bitcount.times do |i|
  maxval, maxcount = transposed[i].tally.max_by { _2 }
  maxval = '1' if maxcount == bitcount.to_f / 2
  minval = maxval == '1' ? '0' : '1'
  a1 << [maxval, minval]

  unless maxbits.count == 1
    maxval, maxcount = maxbits.transpose[i].tally.max_by { _2 }
    maxval = '1' if maxcount == maxbits.length.to_f / 2
    maxbits = maxbits.filter { _1[i] == maxval }
  end

  next if minbits.count == 1

  minval, mincount = minbits.transpose[i].tally.min_by { _2 }
  minval = '0' if mincount == minbits.length.to_f / 2
  minbits = minbits.filter { _1[i] == minval }
end

puts a1.transpose.map {_1.join.to_i(2)}.reduce(:*)
puts [maxbits, minbits].map { _1.join.to_i(2) }.reduce(:*)