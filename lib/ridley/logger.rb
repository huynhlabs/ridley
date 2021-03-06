module Ridley
  module Logging
    class Logger < Logger
      def initialize(device = STDOUT)
        super
        self.level = Logger::WARN
        @filter_params = Array.new
      end

      # Reimplements Logger#add adding message filtering. The info,
      # warn, debug, error, and fatal methods all call add.
      #
      # @param [Fixnum] severity
      #   an integer measuing the severity - Logger::INFO, etc.
      # @param [String] message = nil
      #   the message to log
      # @param [String] progname = nil
      #   the program name performing the logging
      # @param  &block
      #  a block that will be evaluated (for complicated logging)
      #
      # @example
      #   log.filter_param("hello")
      #   log.info("hello world!") => "FILTERED world!"
      #
      # @return [Boolean]
      def add(severity, message = nil, progname = nil, &block)
        severity ||= Logger::UNKNOWN
        if @logdev.nil? or severity < @level
          return true
        end
        progname ||= @progname
        if message.nil?
          if block_given?
            message = yield
          else
            message = progname
            progname = @progname
          end
        end
        @logdev.write(
          format_message(format_severity(severity), Time.now, progname, filter(message)))
        true
      end

      def filter_params
        @filter_params.dup
      end

      def filter_param(param)
        @filter_params << param unless filter_params.include?(param)
      end

      def clear_filter_params
        @filter_params.clear
      end

      def filter(message)
        filter_params.each do |param|
          message.gsub!(param.to_s, 'FILTERED')
        end
        message
      end
    end
  end
end
