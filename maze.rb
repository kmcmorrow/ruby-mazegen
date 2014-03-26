# http://mazeworks.com/mazegen/mazetut/index.htm
# backtrack solution  border    walls
# 0 0 0 0   0 0 0 0   0 0 0 0   0 0 0 0
# W S E N   W S E N   W S E N   W S E N

class Maze
  attr_reader :maze

  ALL_WALLS = 0b1111
  NORTH_WALL = 0b1
  EAST_WALL = 0b10
  SOUTH_WALL = 0b100
  WEST_WALL = 0b1000

  NORTH_BORDER = 0b10000
  EAST_BORDER = 0b100000
  SOUTH_BORDER = 0b1000000
  WEST_BORDER = 0b10000000
  
  def initialize(width, height)
    cell = 0b0000000000000000
    cell |= ALL_WALLS
    @maze = Array.new(height) { Array.new(width, cell) }
    setup_borders
    generate_maze
  end

  def to_s
    @maze.each do |row|
      row.each do |cell|
        printf "%016b ", cell
      end
      puts
    end
    puts
  end

  private

  def setup_borders
    @maze.each do |row|
      row[0] |= 0b10000000
      row[-1] |= 0b100000
    end
    @maze[0].each_index { |cell| @maze[0][cell] |= 0b10000 }
    @maze[-1].each_index { |cell| @maze[-1][cell] |= 0b1000000 }
  end

  def generate_maze
    cell_stack = []
    total_cells = @maze.length * @maze[0].length
    current_cell = { x: 0, y: 0 }
    visited_cells = 1
    
    while visited_cells < total_cells
      neighbour = find_neighbour current_cell
      unless neighbour.nil?
        knock_down_wall current_cell, neighbour
        cell_stack << current_cell
        current_cell = neighbour
        visited_cells += 1
      else
        current_cell = cell_stack.pop
      end
    end
  end

  def find_neighbour(cell)
    neighbours = []
    if get_cell(cell) & WEST_BORDER == 0
      neighbours << { x: cell[:x] - 1, y: cell[:y] }
    end
    if get_cell(cell) & EAST_BORDER == 0
      neighbours << { x: cell[:x] + 1, y: cell[:y] }
    end
    if get_cell(cell) & NORTH_BORDER == 0
      neighbours << { x: cell[:x], y: cell[:y] - 1 }
    end
    if get_cell(cell) & SOUTH_BORDER == 0
      neighbours << { x: cell[:x], y: cell[:y] + 1 }
    end

    neighbours.select! do |c|
      get_cell(c) & ALL_WALLS == 0b1111
    end

    unless neighbours.empty?
      neighbours.sample
    else
      nil
    end
  end

  def knock_down_wall(cell1, cell2)
    if cell1[:y] == cell2[:y] # beside each other
      if cell1[:x] < cell2[:x]
        @maze[cell1[:y]][cell1[:x]] ^= EAST_WALL
        @maze[cell2[:y]][cell2[:x]] ^= WEST_WALL
      else
        @maze[cell1[:y]][cell1[:x]] ^= WEST_WALL
        @maze[cell2[:y]][cell2[:x]] ^= EAST_WALL
      end
    else # above or below
      if cell1[:y] < cell2[:y]
        @maze[cell1[:y]][cell1[:x]] ^= SOUTH_WALL
        @maze[cell2[:y]][cell2[:x]] ^= NORTH_WALL
      else
        @maze[cell1[:y]][cell1[:x]] ^= NORTH_WALL
        @maze[cell2[:y]][cell2[:x]] ^= SOUTH_WALL
      end
    end
  end

  def get_cell(location)
    @maze[location[:y]][location[:x]]
  end
end

