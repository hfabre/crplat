module Crplat
  class HelpCommand < Command

    def initialize(@server : Server, @client : Client)
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
      <<-STR
        List of available commands:

          - /help: Show this message.
          - /nickname new_nickname: Set your nickname to new_nickname.
          - /leave id: Leave channel.
          - /join id: Join channel.
          - /channels: List all channel.
          - /select id: Change user current channel.
          - /create name: Create new channel.
          - /channel id msg: Send direct message to channel without changing current channel.

      STR
    end
  end
end
