require 'ghundle/config'
require 'rainbow'

module Ghundle
  module Command
    # Provides the basic interface of a Ghundle command. Includes some helper
    # methods that are available in all command objects.
    #
    # Inheritors are expected to override the #call instance method, and they
    # will have access to the command-line arguments through the #args method.
    #
    class Common
      attr_reader :args

      def self.call(*args)
        new(*args).call
      end

      def initialize(*args)
        @args = args
      end

      private

      def hook_description(hook)
        [
          Rainbow(hook.name).yellow,
          "  - version:     #{hook.metadata.version}",
          "  - types:       #{hook.metadata.types.join(', ')}",
          "  - description: #{hook.metadata.description}",
        ].join("\n")
      end

      def say(message)
        print Rainbow('>> ').green.bright
        puts Rainbow(message).green
      end

      def error(*args)
        raise AppError.new(*args)
      end

      def config
        @config ||= Config
      end

      def possible_hook_types
        %w{
          applypatch-msg
          commit-msg
          post-applypatch
          post-checkout
          post-commit
          post-merge
          post-receive
          post-rewrite
          post-update
          pre-applypatch
          pre-auto-gc
          pre-commit
          pre-push
          pre-rebase
          pre-receive
          prepare-commit-msg
          update
        }
      end
    end
  end
end
