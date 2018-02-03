module Crplat
  class Server
    def initialize(@host : String = "localhost", @port : Int32 = 1234)
      @server = TCPServer.new(host, port)
      @current_client_id = 0
      @current_channel_id = 1
      @clients = [] of Client
      @channels = [] of Channel
      @main_channel = Channel.new(@current_channel_id, "main")
      @channels << @main_channel
    end

    def run
      puts "Server running on #{@host}:#{@port}"

      while socket = @server.accept?
        spawn handle_new_client(socket)
      end
    end

    def broadcast_message(from : Client, msg : String, to : Channel)
      to.users.each do |client|
        client.socket.send("#{from.nickname}: #{msg}\n") unless from.id == client.id
      end
    end

    private def handle_new_client(socket : TCPSocket)
      @current_client_id += 1
      client = Client.new(@current_client_id, socket)
      @clients << client
      @main_channel.add_user(client)
      broadcast_message(client, "joined your channel.", @main_channel)

      loop do
        msg = socket.gets
        puts "Received: #{msg}"
        if msg
          if msg.starts_with?("/")
            handle_command(client, msg)
          else
            broadcast_message(client, msg, @main_channel)
          end
        else
          broadcast_message(client, "disconnected.", @main_channel)
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
      when "/leave_channel"
        channel_id = array.last.to_i
        channel = find_channel(channel_id)
        unless channel.nil?
          channel.remove_user(client)
          client.socket.send("Channel #{channel.name} left.\n")
        end
      when "/help"
        msg = <<-STR
          List of available commands:

            - /help: Show this message.
            - /nickname new_nickname: Set your nickname to new_nickname.
            - /leave_channel id: Leave channel.
            - /join_channel id: Join channel.
            - /channels: List all channel
        STR

        client.socket.send(msg)
      else
        client.socket.send("Unkown command #{cmd}, type /help to see available commands.\n")
      end
    end

    private def find_client(client_id : Int32)
      @clients.each { |client| return client if client.id == client_id }
    end

    private def find_channel(channel_id : Int32)
      @channels.each { |channel| return channel if channel.id == channel_id }
    end
  end
end
