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

    def add_channel(channel : Channel)
      @channels << channel unless @channels.includes?(channel)
    end

    private def handle_new_client(socket : TCPSocket)
      @current_client_id += 1
      client = Client.new(@current_client_id, socket, @main_channel)
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
            broadcast_message(client, msg, client.current_channel)
          end
        else
          broadcast_message(client, "disconnected.", client.current_channel)
          break
        end
      end
    end

    private def handle_command(client : Client, msg : String)
      array = msg.split(" ")
      cmd = array.first

      case cmd
      when "/nickname"
        SetNicknameCommand.new(self, client, array[1..-1].join(" ")).process
      when "/leave"
        channel = find_channel(array.last.to_i)
        LeaveCommand.new(self, client, channel).process unless channel.nil?
      when "/join"
        channel = find_channel(array.last.to_i)
        JoinCommand.new(self, client, channel).process unless channel.nil?
      when "/select"
        channel = find_channel(array.last.to_i)
        SelectCommand.new(self, client, channel).process unless channel.nil?
      when "/channels"
        ChannelsCommand.new(self, client, @channels).process
      when "/create"
        unless array.last.nil?
          @current_channel_id += 1
          CreateCommand.new(self, client, @current_channel_id, array.last).process
        end
      when "/channel"
        id = array[1].to_i
        msg = array[2..-1].join(" ")
        ChannelCommand.new(server, client, id, msg).process
      when "/help"
        HelpCommand.new(self, client).process
      else
        client.socket.send("Unkown command #{cmd}, type /help to see available commands.\n")
      end
    end

    def find_client(client_id : Int32) : Client | Nil
      @clients.each { |client| return client if client.id == client_id }
    end

    def find_channel(channel_id : Int32) : Channel | Nil
      @channels.each { |channel| return channel if channel.id == channel_id }
    end
  end
end
