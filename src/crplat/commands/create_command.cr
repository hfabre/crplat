module Crplat
  class CreateCommand < Command

    def initialize(@server : Server, @client : Client, @channel_id : Int32, @channel_name : String)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      @channel = Channel.new(@channel_id, @channel_name)
      @server.add_channel(channel)
    end

    def validate_params
      true
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      "#{channel.name} created.\n"
    end
  end
end
