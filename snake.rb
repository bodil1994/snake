require 'ruby2d'
# Documentation https://www.ruby2d.com/
# Resource  https://dev.to/joaocardoso193/i-made-a-simple-snake-game-with-ruby-2d-4on4 ; https://www.youtube.com/watch?v=hLvlHCnv_k8&list=PLWcnu8hOlT9VlS_VjNQ6fviGI2z8Vgrm_&ab_channel=MarioVisic
# The Ruby 2D Package allows you to export it to iOS using ruby2d build --ios <your_game_file_name.rb>. It also allows you to export to a Javascript and HTML package to be deployed on the web using ruby2d build --web <your_game_file_name.rb>. However, the web feature is currently disabled as it's being upgraded.

set background: 'navy', fps_cap: 5, title: "Snake", diagnostics: true

GRID_SIZE = 20 #grid size is 20 pixels

#for default window size of 480px * 640px, width is 32 (640/20) and height is 24 (480/20) at grid size = 20 pixels
GRID_WIDTH = Window.width / GRID_SIZE # how many columns
GRID_HEIGHT = Window.height / GRID_SIZE # how many rows


# Move Snake

  # Move Snake V2
  # when snake hits wall comes out the other side

  # Move Snake V3
  # Dies when it hits itself

  # Move Snake V4
  # gets a bit faster everytime it hits food


# Snake Food MVP
  # box in random place in different colour appears
  # disappear when snake hits
  # appear in new random place

# Initialize a Snake
# Create array of positions to draw squares in
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

snake = Snake.new

class Game
  def initialize(snake)
    @snake = snake
    @paused = false
    @food_x = food_coord[0]
    @food_y = food_coord[1]
    @finished = false
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
    Text.new(text_message, color: 'white', x: 10, y: 10, size: 25)
  end

  def food_eaten?
    @snake.positions.include?([@food_x, @food_y])
  end

  def new_food
    @food_x = food_coord[0]
    @food_y = food_coord[1]
  end

  def text_message

  end

  def finished?
    @finished
  end

  def new_game
    @finish = false
  end

  def finish
    @finish = true
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

game = Game.new(snake)

# Move Snake V1
  # Snake box size of grid space, not moving
  # Press arrow key moves in that direction every frame until another arrow key is pressed then direction changes to that


update do
  clear

  unless game.paused? && game.finished?
    snake.move
  end

  if game.food_eaten?
    game.new_food
    snake.growing = true
  end

  snake.draw
  game.draw_food

  game.finish if snake.hit_itself?
end

on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key)
    if snake.can_change_direction?(event.key) && !game.paused?
        snake.direction = event.key
    end
  elsif event.key == 'p'
    game.paused? ? game.unpause : game.pause
  end
end

show
