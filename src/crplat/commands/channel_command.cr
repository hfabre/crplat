module Crplat
  class ChannelCommand < Command

    def initialize(@server : Server, @client : Client, @channel : Channel, @msg : String)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      @server.broadcast_message(@client, @msg, @channel)
    end

    def validate_params
      true
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      ""
    end
  end
end
