module Crplat
  class ChannelsCommand < Command

    def initialize(@server : Server, @client : Client, @channels : Array(Channel))
    end

    def execute_cmd
      nil
    end

    def validate_params
      true
    end

    def error_msg
      ""
    end

    def success_msg
        msg = ""
        @channels.each { |channel| msg += "#{channel.name}-#{channel.id}\n"}
        msg
    end
  end
end
