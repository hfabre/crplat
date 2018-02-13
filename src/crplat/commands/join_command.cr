module Crplat
  class JoinCommand < Command

    def initialize(@server : Server, @client : Client, @channel : Channel)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      @channel.remove_user(@client)
      @server.broadcast_message(@client, "joined your channel\n", @channel)
    end

    def validate_params
      true
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      "Channel #{@channel.name} joined.\n"
    end
  end
end
