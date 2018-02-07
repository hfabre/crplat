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
      if valid?
        execute_cmd
        @client.socket.send(success_msg)
      else
        @client.socket.send(error_msg)
      end
    end
  end
end
