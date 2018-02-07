module Crplat
  class ChannelCommand < Command
    @channel : Channel | Nil

    def initialize(@server : Server, @client : Client, @channel_id : Int32, @msg : String)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      # TODO: Open an issue, i don't think compiler should act like this
      unless @channel.nil?
        @server.broadcast_message(@client, @msg, @channel)
      end
    end

    def validate_params
      @channel = @server.find_channel(@channel_id)
      if @channel.nil?
        @errors[:channel] = "Channel: not found"
      end

      @errors.empty?
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      ""
    end
  end
end
