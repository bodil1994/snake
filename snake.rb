require 'ruby2d'
# Documentation https://www.ruby2d.com/
# Resource  https://dev.to/joaocardoso193/i-made-a-simple-snake-game-with-ruby-2d-4on4 ; https://www.youtube.com/watch?v=hLvlHCnv_k8&list=PLWcnu8hOlT9VlS_VjNQ6fviGI2z8Vgrm_&ab_channel=MarioVisic
# The Ruby 2D Package allows you to export it to iOS using ruby2d build --ios <your_game_file_name.rb>. It also allows you to export to a Javascript and HTML package to be deployed on the web using ruby2d build --web <your_game_file_name.rb>. However, the web feature is currently disabled as it's being upgraded.
# build --> ruby2d build --native snake.rb
set background: 'navy', fps_cap: 5, title: "Snake", diagnostics: true

GRID_SIZE = 20 #grid size is 20 pixels

#for default window size of 480px * 640px, width is 32 (640/20) and height is 24 (480/20) at grid size = 20 pixels
GRID_WIDTH = Window.width / GRID_SIZE # how many columns
GRID_HEIGHT = Window.height / GRID_SIZE # how many rows

class Snake
  attr_writer :direction, :growing
  attr_reader :positions

  def initialize
    @positions = [[2, 2], [2, 3], [2, 4], [2, 5]]
    @direction = 'down'
    @growing = false
  end

  def draw
    @positions.each do |element|
      Square.new(x: element[0] * GRID_SIZE, y: element[1]* GRID_SIZE, size: GRID_SIZE-1)
    end
  end

  # snake moves by deleting first element in array and adding new head
  def move
    @positions.shift unless @growing
    @growing = false

    case @direction
    when 'up'
      @positions.push(magic_wall_coords(head[0], head[1] - 1))
    when 'down'
      @positions.push(magic_wall_coords(head[0], head[1] + 1))
    when 'left'
      @positions.push(magic_wall_coords(head[0] - 1, head[1]))
    when 'right'
      @positions.push(magic_wall_coords(head[0] + 1, head[1]))
    end
  end

  def hit_itself?
    @positions.uniq.length != @positions.length
  end

  # ensure snake appears on other side of window
  def magic_wall_coords(x, y)
    # e.g. x stays same until larger than width, with = 32, x = 34 (left window) -> x = 2; x in window x=6, 6/32 = 0, leaved 6 --> x stay 6
   [x % GRID_WIDTH, y % GRID_HEIGHT]

  end

  def can_change_direction?(new_direction)
    case @direction
    when 'up' then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end
  end

  def head
    @positions.last
  end

  def x
    head[0]
  end

  def y
    head[1]
  end
end

class Game
  attr_reader :score

  def initialize(snake)
    @snake = snake
    @paused = false
    @food_x = food_coord[0]
    @food_y = food_coord[1]
    @finished = false
    @score = 0
  end

  def food_coord
    all_coords = []
    # creates all possible combinations of x and y
    for x in (0..GRID_WIDTH - 1)
      for y in (0..GRID_HEIGHT - 1)
        all_coords.append([x,y])
      end
    end
    empty_coords = all_coords.reject do |coord|
      @snake.positions.include?(coord)
    end
    empty_coords.sample
  end

  def draw
    unless finished?
      Square.new(x: @food_x * GRID_SIZE, y: @food_y * GRID_SIZE, size: GRID_SIZE - 1, color: 'red')
    end
    Text.new(text_message, color: 'white', x: 10, y: 10, size: 16)
  end

  def food_eaten?
    @snake.positions.include?([@food_x, @food_y])
  end

  def new_food
    @food_x = food_coord[0]
    @food_y = food_coord[1]
    @score += 1
  end

  def text_message
    if finished?
      "Game over, you scored #{@score} points. Press s to start a new game."
    elsif paused?
      "Game paused, your current score is #{@score} points. Press p to continue."
    end
  end

  def finished?
    @finished
  end

  def finish
    @finished = true
  end

  def pause
    @paused = true
  end

  def unpause
    @paused = false
  end

  def paused?
    @paused
  end
end

snake = Snake.new
game = Game.new(snake)

update do
  clear

  game.finish if snake.hit_itself?

  unless game.paused? || game.finished?
    snake.move
  end

  if game.food_eaten?
    game.new_food
    snake.growing = true
  end

  snake.draw
  game.draw
end

on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key)
    if snake.can_change_direction?(event.key) && !game.paused?
        snake.direction = event.key
    end
  elsif event.key == 'p'
    game.paused? ? game.unpause : game.pause
  elsif event.key == 's'
    snake = Snake.new
    game = Game.new(snake)
  end
end

show
