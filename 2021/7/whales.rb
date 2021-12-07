require 'pry'

data = File.read('data.txt').split(',').map(&:to_i)

class CrabSubGroup

  def initialize(path, constant_burn: true)
    @positions = File.read(path).split(',').map(&:to_i)
    @constant_burn = constant_burn
  end

  def spread
    (@positions.min..@positions.max)
  end

  def best_position
    @best_position ||= spread.min_by do |distance|
      @constant_burn ? constant_burn(distance) : geometric_burn(distance)
    end
  end

  def minimum_fuel_required
    @minimum_fuel_required ||= @positions.map do |i| 
      @constant_burn ? constant_min_fuel(i) : geometric_min_fuel(i)
    end.sum
  end

  private

  def constant_min_fuel(position)
    (position - best_position).abs
  end

  def geometric_min_fuel(position)
    t = (position - best_position).abs
    t * (t + 1) / 2
  end

  def constant_burn(position)
    @positions.map {|i| (i - position).abs}.sum
  end

  def geometric_burn(position)
    @positions.map {|i| (i - position).abs * ((i - position).abs + 1) / 2}.sum
  end

end

p1 = CrabSubGroup.new('data.txt')
p2 = CrabSubGroup.new('data.txt', constant_burn: false)

puts "Minimum fuel required: #{p1.minimum_fuel_required}"
puts "Minimum geometric fuel required: #{p2.minimum_fuel_required}"
