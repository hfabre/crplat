module Crplat
  class Channel
    getter name, id, users

    def initialize(@id : Int32, @name : String)
      @users = [] of Client
    end

    def add_user(user : Client)
      @users << user unless user.nil? || @users.includes?(user)
    end

    def remove_user(user : Client)
      @users.delete(user) unless user.nil?
    end
  end
end
