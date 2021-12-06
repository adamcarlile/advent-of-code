require 'pry'

class LanternfishPopulation
  attr_accessor :population_bucket

  def initialize(data:)
    @data = File.read(data).split(',').map(&:to_i)

  end

  def bucket
    @bucket ||= Array.new(9,0).tap do |array|
      @data.each {|x| array[x] += 1}
    end
  end

  def simulate!(cycles:)
    cycles.times do
      bucket[7] += bucket[0]
      bucket.rotate!(1) 
    end
  end

  def sum
    bucket.sum
  end

end


o1 = LanternfishPopulation.new(data: "data.txt")
o1.simulate!(cycles: 80)
puts o1.sum

o2 = LanternfishPopulation.new(data: "data.txt")
o2.simulate!(cycles: 256)
puts o2.sum
