require 'githooks/command'
require 'githooks/app_error'

module Githooks
  module Command
    # Runs the given hook, providing it with the rest of the positional
    # arguments on the command-line.
    #
    class Run < Common
      def call
        name = args.first
        hook = Hook.new(name)
        say "Running hook #{hook.name}"

        hook.run(*args[1 .. -1])
      end
    end
  end
end