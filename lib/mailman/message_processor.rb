module Mailman
  # Turns a raw email into a +Mail::Message+ and passes it to the router.
  class MessageProcessor

    # @param [Hash] options the options to create the processor with
    # @option options [Router] :router the router to pass processed
    #   messages to
    def initialize(options)
      @router = options[:router]
    end

    # Converts a raw email into a +Mail::Message+ instance, and passes it to the
    # router.
    # @param [String] message the message to process
    def process(message)
      message = Mail.new(message)
      Mailman.logger.info "Got new message from '#{message.from.first}' with subject '#{message.subject}'."
      @router.route(message)
    end

    ##
    # Processes a +Maildir::Message+ instance.
    # Move mail from new to cur directory of Maildir
    #
    # If process failed the Mail is not move and mark like see
    #
    # @params[MailDir::Message] message the mail get from Maildir
    #
    def process_maildir_message(message)
      process(message.data)
      message.process # move message to cur
      message.seen!
    end

  end
end
