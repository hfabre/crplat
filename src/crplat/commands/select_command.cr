module Crplat
  class SelectCommand < Command

    def initialize(@server : Server, @client : Client, @channel : Channel)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      @client.current_channel = @channel
    end

    def validate_params
      true
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      "Current channel changed to #{@channel.name}\n"
    end
  end
end
