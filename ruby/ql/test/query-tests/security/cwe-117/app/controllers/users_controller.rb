require 'logger'

class UsersController < ApplicationController
  include ERB::Util

  def init_logger
    if @logger == nil
      @logger = Logger.new STDOUT
    end
  end

  def read_from_params
    init_logger

    unsanitized = params[:foo]
    @logger.debug unsanitized             # BAD: unsanitized user input
    @logger.error "input: " + unsanitized # BAD: unsanitized user input

    sanitized = unsanitized.gsub("\n", "")
    @logger.fatal sanitized            # GOOD: sanitized user input
    @logger.warn "input: " + sanitized # GOOD: sanitized user input

    unsanitized2 = unsanitized.sub("\n", "")
    @logger.info do
      unsanitized2                      # BAD: partially sanitized user input
    end
    @logger << "input: " + unsanitized2 # BAD: partially sanitized user input
  end

  def read_from_cookies
    init_logger

    unsanitized = cookies[:bar]
    @logger.add(Logger::INFO) { unsanitized }             # BAD: unsanitized user input
    @logger.log(Logger::WARN) { "input: " + unsanitized } # BAD: unsanitized user input
  end

  def html_sanitization
    init_logger

    sanitized = html_escape params[:baz]
    @logger.debug unsanitized             # GOOD: sanitized user input
    @logger.debug "input: " + unsanitized # GOOD: sanitized user input
  end
end
