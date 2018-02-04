module Crplat
  class Client
    property nickname, current_channel

    getter socket, id

    def initialize(@id : Int32, @socket : TCPSocket, @current_channel : Channel, @nickname : String = "Anonymous")
    end
  end
end
