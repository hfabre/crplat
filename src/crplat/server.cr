class Server
  def initialize(@host : String = "localhost", @port : Int32 = 1234)
    @server = TCPServer.new(host, port)
    @current_id = 0
    @clients = [] of Client
  end

  def run
    puts "Server running on #{@host}:#{@port}"

    while socket = @server.accept?
      spawn handle_new_client(socket)
    end
  end

  def broadcast_message(from : Client, msg : String)
    @clients.each do |client|
      client.socket.send("#{from.nickname}: #{msg}\n") unless from.id == client.id
    end
  end

  private def handle_new_client(socket : TCPSocket)
    @current_id += 1
    client = Client.new(@current_id, socket)
    @clients << client
    broadcast_message(client, "joined your channel.")

    loop do
      msg = socket.gets
      puts "Received: #{msg}"
      if msg
        if msg.starts_with?("/")
          handle_command(client, msg)
        else
          broadcast_message(client, msg)
        end
      else
        broadcast_message(client, "disconnected.")
        break
      end
    end
  end

  private def handle_command(client : Client, msg : String)
    array = msg.split(" ")
    cmd = array.first

    case cmd
    when "/nickname"
      client.nickname = array.last
      client.socket.send("Nickname changed to #{client.nickname}.\n")
    when "/help"
      msg = <<-STR
        List of available commands:

          - /help: Show this message.
          - /nickname new_nickname: Set your nickname to new_nickname.
      STR

      client.socket.send(msg)
    else
      client.socket.send("Unkown command #{cmd}, type /help to see available commands.\n")
    end
  end
end
