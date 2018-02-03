module Crplat
  class Client
    property nickname

    getter socket, id

    def initialize(@id : Int32, @socket : TCPSocket, @nickname : String = "Anonymous")
    end
  end
end
