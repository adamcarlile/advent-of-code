require 'pry'
require 'benchmark'

class Factory

  def initialize(input:, rules:)
    @input = Polymer.new(input)
    @rules = rules.split("\n").map { |r| r.split(" -> ") }.to_h
  end

  def results
    @results ||= [@input]
  end

  def polymerise!(steps: 1)
    steps.times do
      o = Benchmark.measure do
        output = []
        results.last.chars.each_cons(2) do |pair|
          insert = @rules[pair.join('')]
          if insert
            output << [pair[0], insert]
          else
            output << [pair[0]]
          end
        end
        output << results.last.chars.last
        @results << Polymer.new(output.flatten.join(''))
      end
      puts o
    end
  end

  def print_results
    puts "Most: #{results.last.most}"
    puts "Least: #{results.last.least}"
    puts "Difference: #{results.last.difference}"
  end

end

class Polymer

  def initialize(input)
    @input = input
  end

  def chars
    @input.chars
  end

  def chemicals
    @chemicals ||= @input.chars.uniq
  end

  def occurences
    @occurences ||= chemicals.map {|x| [x, @input.count(x)] }.to_h
  end

  def most
    @most ||= occurences.max_by {|k,v| v}
  end

  def least
    @least ||= occurences.min_by {|k,v| v}
  end

  def difference
    most[1] - least[1]
  end

end


data = File.read("data.txt").split("\n\n")
input = data[0]
rules = data[1]

factory = Factory.new(input: input, rules: rules)


polymer_template, pair_insertion_rules = data

@rules = {}
@current_pairs = Hash.new(0)
@element_tally = Hash.new(0)

pair_insertion_rules.each_line(chomp: true) do |line|
  pair, insert = line.split(" -> ")
  @rules[pair] = insert
end

polymer_template.chars.each_cons(2) { |pair| @current_pairs[pair.join] += 1 }
polymer_template.chars.each { |char| @element_tally[char] += 1 }

40.times do |step|
  if step == 10
    min, max = @element_tally.minmax_by { |_k, v| v }
    puts "part 1: #{max[1] - min[1]}"
  end
  @current_pairs.clone.each do |pair, pair_occurances|
    element_to_be_insert = @rules[pair]
    @element_tally[element_to_be_insert] += pair_occurances
    @current_pairs[pair] -= pair_occurances
    @current_pairs[pair[0] + element_to_be_insert] += pair_occurances
    @current_pairs[element_to_be_insert + pair[1]] += pair_occurances
  end
end

min, max = @element_tally.minmax_by { |_k, v| v }
puts "part 2: #{max[1] - min[1]}"
