lines = File.open('data.txt', 'r') { |f| f.readlines }.map { |l| l.chomp.split('-').map(&:to_sym) }

# if two nodes are connected, they will appear in each other's entry.
# e.g. A -- B -- C => { :a => [:b], :b => [:a, :c], :c => [:b] }
nodes = {}
lines.each do |a, b|
  nodes[a] ||= []
  nodes[a] << b
  nodes[b] ||= []
  nodes[b] << a 
end

# Recursively (depth-first) search for valid paths. Allows for one lowercase node to be visited twice.
# @param current The node to start from.
# @param dest    The destination node.
# @param nodes   The list of nodes. (couldn't find a better way to do this ::shrug::)
# @param duplicate_node The one node that is allowed to be visited twice.
# @return Array<Array<Symbol>>  The paths, each represented by an array of symbols.
def find_paths(current, dest, nodes, duplicate_node=nil, visited_points=[], all_paths=[])
  # base condition: if the current node is what we want, just stop here.
  return all_paths << visited_points + [dest] if current == dest
  # otherwise, path from each connected node to the destination.
  nodes[current].each do |node|
    # ...except if the node is invalid (lowercase node that's already been visited)
    if visited_points.include?(node) && node.downcase == node
      next unless node == duplicate_node && visited_points.count(node) == 1
    end
    find_paths(node, dest, nodes, duplicate_node, visited_points + [current], all_paths)
  end  
  return all_paths
end

# part 1
p find_paths(:start, :end, nodes).size

# part 2
paths = []
nodes.keys.select { |node| node.downcase == node && ![:start, :end].include?(node)}.each do |duplicate_node|
  paths += find_paths(:start, :end, nodes, duplicate_node)
end
p paths.uniq.size