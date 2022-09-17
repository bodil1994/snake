require 'ruby2d'
# Documentation https://www.ruby2d.com/
# Resource  https://dev.to/joaocardoso193/i-made-a-simple-snake-game-with-ruby-2d-4on4 ; https://www.youtube.com/watch?v=hLvlHCnv_k8&list=PLWcnu8hOlT9VlS_VjNQ6fviGI2z8Vgrm_&ab_channel=MarioVisic
# The Ruby 2D Package allows you to export it to iOS using ruby2d build --ios <your_game_file_name.rb>. It also allows you to export to a Javascript and HTML package to be deployed on the web using ruby2d build --web <your_game_file_name.rb>. However, the web feature is currently disabled as it's being upgraded.

set background: 'navy'
set fps_cap: 20

GRID_SIZE = 20 #grid size is 20 pixels

#for default window size of 480px * 640px, width is 32 (640/20) and height is 24 (480/20) at grid size = 20 pixels
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE
show
