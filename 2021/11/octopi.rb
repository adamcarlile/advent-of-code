require 'benchmark'

class Octopus
  attr_reader :x, :y, :energy
  # collect all variations but remove duplicates, these are all of our neighbor locations
  NEIGHBORS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]
  def initialize(x:, y:, energy:)
    @x, @y = x, y
    @energy = energy
    @flash = false
  end

  def location
    [x,y]
  end

  def neighbors
    NEIGHBORS.map { |neighbor| [@x + neighbor[0], @y + neighbor[1]]}
  end

  def increase
    @energy += 1
  end

  def can_flash?
    @energy > 9 && !@flash
  end


  def just_flashed?
    @energy == 0
  end

  def power_up!
    @energy += 1
  end

  def on!
    @flash = true
  end

  def on?
    @flash
  end

  def off?
    @energy.zero?
  end

  def off!
    @flash = false
    @energy = 0
  end
end

class Cave
  def initialize (levels)
    @folks = {}

    levels.each.with_index do |line, y|
      line.each.with_index do |val, x|
        @folks[[x, y]] = Octopus.new(x: x, y: y, energy: val)
      end
    end
  end

  def everyone
    @folks.values
  end

  def [](location)
    @folks[location]
  end

  def get_neighbors(octopus)
    octopus.neighbors.map { |n| self[n] }.compact
  end

  def step
    everyone.map(&:increase)

    while can_flash?
      everyone.filter(&:can_flash?).each do |octopus|
        octopus.on!
        get_neighbors(octopus).map(&:power_up!)
      end
    end

    turn_off
  end

  def process(count)
    count.times.collect do |index|
      step
      who_flashed?
    end.inject(0) {|memo, list| memo + list.size}
  end

  def run
    counter = 0
    until everyone.all?(&:off?)
      counter += 1
      step
    end

    puts "everyone is on at #{counter}"
  end

  def turn_off
    everyone.filter(&:on?).each do |octopus|
      octopus.off!
    end
  end

  def anyone_flashed?
    everyone.any(&:just_flashed?)
  end

  def who_flashed?
    everyone.filter(&:just_flashed?)
  end

  def can_flash?
    everyone.any?(&:can_flash?)
  end

  def print
    result = []
    @folks.each do  |k, v|
      result[k[1]] = [] if result[k[1]].nil?
      result[k[1]][k[0]] = [] if result[k[1]][k[0]].nil?
      result[k[1]][k[0]] = v.energy
    end

    result.each { |result| puts result.join("")}
  end

end

data = File.read("data.txt").lines.map(&:chomp).map{ |row| row.split("").map(&:to_i)}

# part 1
cave = Cave.new(data)
result = cave.process(100)
puts "flashes #{result}"

# part 2
cave = Cave.new(data)

puts Benchmark.measure {
  cave.run
}