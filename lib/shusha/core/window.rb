require 'publisher'

module Shusha
  class Window < Gosu::Window
    extend Publisher
  end
end