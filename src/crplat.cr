require "socket"
require "./crplat/*"
require "./crplat/commands/*"

module Crplat
  Server.new.run
end
