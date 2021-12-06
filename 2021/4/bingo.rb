require 'pry'
require 'matrix'

class Game

  attr_reader :available_numbers

  def initialize(path)
    @data = File.read(path).split("\n").reject {|x| x.empty? }
    @available_numbers = @data.shift.split(',').map(&:to_i)
  end

  def start!
    available_numbers.each {|x| draw_ball!(x) }
  end

  def draw_ball!(ball)
    boards.each do |x|
      x.ball_drawn!(ball)
      winning_order << x if x.winner? && !winning_order.include?(x)
    end
  end

  def first_board
    winning_order.first
  end

  def last_board
    winning_order.last
  end

  private

  def winning_order
    @winning_order ||= []
  end

  def boards
    @boards ||= @data.map.each_slice(5).to_a.map do |board|
      Board.new(board.map {|x| x.split.map(&:to_i) })
    end
  end

end

class Board

  def initialize(array)
    @data = array
    @drawn_balls = []
  end

  def ball_drawn!(number)
    @drawn_balls << number
    matrix[*matrix.index(number)] = "X" if matrix.index(number)
  end

  def winner?
    return winning_score if matrix.row_vectors.map {|x| x.uniq }.any? {|x| x.length == 1 }
    return winning_score if matrix.column_vectors.map {|x| x.uniq }.any? {|x| x.length == 1 }
  end

  def winning_score
    @winning_score ||= (matrix.sum(&:to_i) * @drawn_balls.last)
  end

  private

  def matrix
    @matrix ||= Matrix.rows(@data)
  end

end

game = Game.new("data.txt")
game.start!

puts "Winning Board: #{game.first_board.winning_score}"
puts "Last Board: #{game.last_board.winning_score}"

binding.pry
