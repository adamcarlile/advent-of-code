class Point
  attr_reader :x, :y

  def initialize(x:, y:)
    @x, @y = x, y
  end

  def location
    [x, y]
  end
  
  def up
    [x, y - 1]
  end

  def down
    [x, y + 1]
  end

  def left
    [x - 1, y]
  end

  def right 
    [x + 1, y]
  end
  
  def neighbors
    [up, left, down, right]
  end

end

class World

  def initialize(data)
    data.split("\n").each.with_index do |line, y|
      line.chars.each.with_index do |val, x|
        points[[x, y]] = Point.new(x: x, y: y) if val != '9'
      end
    end
  end

  def points
    @points ||= {}
  end

  def basins
    @basins ||= Array.new(3) { 0 }
  end

  def solve!
    points.each do |(x, y), point|
      basin = explore(point).uniq.size

      if basins.first < basin
        basins.shift
        basins.push(basin).sort!
      end
    end

    basins.reduce(&:*)
  end

  private

  def explore(point, basin=[])
    return basin if point.nil?

    basin << points.delete(point.location)

    point.neighbors.map do |x, y|
      explore(points[[x, y]], basin)
    end.flatten
  end
end

puts World.new(File.read('data.txt')).solve!