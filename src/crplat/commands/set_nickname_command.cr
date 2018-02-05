module Crplat
  class SetNicknameCommand < Command

    def initialize(@server : Server, @client : Client, @new_name : String)
      @errors = {} of Symbol => String
    end

    def execute_cmd
      @client.nickname = @new_name
    end

    def validate_params
      if @new_name.size >= 16
        @errors[:nickname] = "Nickname: #{@new_name} is too long (more than 16 characters)"
      end

      @errors.empty?
    end

    def error_msg
      "#{self.class.name} failed.\n#{@errors.values.join("\n")}\n"
    end

    def success_msg
      "Nickname changed to #{@new_name}\n"
    end
  end
end
