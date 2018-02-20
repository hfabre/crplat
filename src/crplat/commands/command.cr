module Crplat
  abstract class Command
    abstract def validate_params
    abstract def execute_cmd
    abstract def success_msg
    abstract def error_msg


    def valid?
      validate_params
    end

    def process
      msg = if valid?
              execute_cmd
              success_msg
            else
              error_msg
            end
      @client.socket.send(msg) unless msg.nil?
    end
  end
end
