#!/usr/bin/env ruby

require 'optparse'

params = {
  num_cols: 20,
  num_rows: 20,
  num_iterations: 2,
  probability_alive: 0.375,
  display_alive: '1',
  display_dead: '0',
}

parser = OptionParser.new do |op|
  op.on("-n", "--num-cols <int>", Integer, "the number of cols") {|v| params[:num_cols] = v }
  op.on("-m", "--num-rows <int>", Integer, "the number of rows") {|v| params[:num_rows] = v }
  op.on("-i", "--num-iterations <int>", Integer, "the number of iterations") {|v| params[:num_iterations] = v }
  op.on("-p", "--probability-alive <float>", Float, "probability a cell is alive at start") {|v| params[:probability_alive] = v }
  op.on("-a", "--display-alive <char>", "the character for alive") {|v| params[:display_alive] = v }
  op.on("-d", "--display-dead <char>", "the character for dead") {|v| params[:display_dead] = v }
end
parser.parse!


class Grid
  ALIVE = 1
  DEAD = 0
  
  attr_accessor :rows
  
  def initialize_board(num_rows, num_cols, probability_alive)
    num_rows.times.with_object([]) do |row_index, board|
      board << Array.new(num_cols) { rand < probability_alive ? ALIVE : DEAD }
    end
  end
  
  def neighbors(m, n)
  
    n_plus_1 = (n + 1 >= @rows.first.size) ? 0 : n + 1
    m_plus_1 = (m + 1 >= @rows.size) ? 0 : m + 1
    return [
      @rows[m][n-1], # left
      @rows[m-1][n], # up
      @rows[m_plus_1][n], # down
      @rows[m][n_plus_1], # right
      @rows[m-1][n-1], # left-up
      @rows[m-1][n_plus_1], # right-up
      @rows[m_plus_1][n-1], # left-down
      @rows[m_plus_1][n_plus_1], # right-down
    ]
  end
  
  def will_be_alive_next_round?(m, n)
    the_neighbors = neighbors(m, n)
    num_alive = the_neighbors.sum
    if num_alive >= 4
      return DEAD
    elsif num_alive < 2
      return DEAD
    else
      return ALIVE
    end
  end
  
  def calculate_new_board
    @rows.each_with_index.map do |row, m|
      row.each_index.map do |n|
        will_be_alive_next_round?(m, n)
      end
    end
  end
  
  def iterate(num)
    (num+1).times do |iteration|
      puts "-" * [@rows.first.size, 14].max
      puts "iteration #{iteration}"
      puts self.to_s
      puts "-" * [@rows.first.size, 14].max
      @rows = calculate_new_board
    end
  end
  
  def initialize(num_rows, num_cols, probability_alive, display_alive, display_dead)
    @rows = initialize_board(num_rows, num_cols, probability_alive)
    @display_alive = display_alive
    @display_dead = display_dead
  end
  
  def to_s
    response = ''
    @rows.each do |row|
      row.each do |cell|
        response << (cell == 1 ? @display_alive : @display_dead)
      end
      response << "\n"
    end
    response
  end
  
  def every_cell
    @rows.flat_map {|row| row }
  end
    
end

grid = Grid.new(
  params[:num_rows],
  params[:num_cols],
  params[:probability_alive],
  params[:display_alive],
  params[:display_dead],
)
grid.iterate(params[:num_iterations])


