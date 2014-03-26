require 'gosu'
require_relative 'maze'

class MazeWindow < Gosu::Window
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600
  FULL_SCREEN = false

  CELL_SIZE = 20
  COLOR = Gosu::Color::YELLOW

  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT, FULL_SCREEN
    self.caption = 'Maze'
    @maze = Maze.new(32, 24).maze
  end

  private

  def update
  end

  def draw
    @maze.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        #puts "draw line from #{x}, #{y} to #{x + CELL_SIZE}, #{y}"
        y = row_index * CELL_SIZE + CELL_SIZE
        x = col_index * CELL_SIZE + CELL_SIZE
        # top
        if cell[0] == 1
          draw_line x, y, COLOR, x + CELL_SIZE, y, COLOR
        end
        # left
        if cell[3] == 1
          draw_line x, y, COLOR, x, y + CELL_SIZE, COLOR
        end
        # right
        if cell[1] == 1
          draw_line x + CELL_SIZE, y, COLOR, x + CELL_SIZE, y + CELL_SIZE, COLOR
        end
        # bottom
        if cell[2] == 1
          draw_line x, y + CELL_SIZE, COLOR, x + CELL_SIZE, y + CELL_SIZE, COLOR
        end
      end
    end
  end

  def needs_cursor?
    true
  end
end

MazeWindow.new.show
