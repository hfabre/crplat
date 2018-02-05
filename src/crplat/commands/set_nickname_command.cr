module Crplat
  class SetNicknameCommand
    include ICommand

    def initialize(@server : Server, @client : Client, @new_name : String)
      @errors = {} of Symbol => String
    end

    def process
      validate_params

      if valid?
        @client.nickname = @new_name
        @client.socket.send(message)
      end
    end

    def validate_params
      @errors[:nickname] = "#{@new_name} is too long (more than 16 characters)\n" if @new_name.size >= 16
    end

    def valid?
      @errors.empty?
    end

    def error_message
      "Failed to change nickname.\n"
    end

    def message
      "Nickname changed to #{@new_name}\n"
    end
  end
end
