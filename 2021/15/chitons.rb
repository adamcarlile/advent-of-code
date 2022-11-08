class PriorityQueue
  def initialize
    @queue = {}
    @map = {}
  end

  def push(obj, prio)
    current_prio = @map[obj]
    if current_prio != prio
      unless current_prio.nil?
        list = @queue[current_prio]
        list.delete(obj)
        @queue.delete(current_prio) if list.empty?
      end
      @queue[prio] ||= []
      @queue[prio] << obj
      @map[obj] = prio
    end
  end

  def pop_min
    pop(@queue.keys.min)
  end

  def pop_max
    pop(@queue.keys.max)
  end

  def priorities
    @queue.keys
  end

  def pop(prio)
    list = @queue[prio]
    obj = list.shift
    @queue.delete(prio) if list.empty?
    @map.delete(obj)
    return obj
  end

  def size
    @queue.map { |_, l| l.size }.sum
  end

  def empty?
    @queue.empty?
  end
end

@map = File.read('data.txt').strip.split("\n").map { |line| line.chars.map(&:to_i) }

def dijkstra(map)
  # Copied from 2018/22. ^_^
  target = Complex(map.first.length - 1, map.length - 1)
  x_range = (0..target.real)
  y_range = (0..target.imag)
  start = Complex(0, 0)
  dist = Hash.new(Float::INFINITY)
  dist[start] = 0
  queue = PriorityQueue.new
  queue.push(start, 0)
  until queue.empty?
    pos = queue.pop_min

    if pos == target
      return dist[target]
    end

    this_dist = dist[pos]
    [ -1i, 1i, -1, 1 ].each do |delta|
      npos = pos + delta
      next unless x_range.include?(npos.real) and y_range.include?(npos.imag)
      ndist = this_dist + map[npos.imag][npos.real]
      if ndist < dist[npos]
        dist[npos] = ndist
        queue.push(npos, ndist)
      end
    end
  end
end

# Part 1
puts "Total risk: #{dijkstra(@map)}"

# Part 2
map5 = []
5.times do |y|
  line5 = Array.new(@map.length) { [] }
  5.times do |x|
    @map.each_with_index do |line, yy|
      line5[yy] += line.map { |val| (val - 1 + x + y) % 9 + 1 }
    end
  end
  map5 += line5
end
puts "Total risk for 5x map: #{dijkstra(map5)}"