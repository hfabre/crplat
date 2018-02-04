module Crplat
  class SetNicknameCommand
    include Icommand

    def initialize(@server : Server, @new_name : String)
      @valid = false
    end

    def validate_params
      @valid = @new_name.is_a?(String)
    end

    def valid?
      @valid
    end

    def error_message

    end

    def process
      
    end
  end
end
