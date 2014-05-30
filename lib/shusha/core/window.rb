require 'publisher'

module Shusha
  class Window < Gosu::Window
    extend Publisher
    can_fire :update, :draw, :button_down, :button_up
  end
end