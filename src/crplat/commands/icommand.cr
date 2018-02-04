module Crplat
  module ICommand
    abstract def validate_params
    abstract def valid?
    abstract def process
    abstract def error_message
    abstract def message
  end
end
