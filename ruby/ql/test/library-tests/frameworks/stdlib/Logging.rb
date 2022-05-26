require 'logger'

class LoggerTest
  @@cls_logger = Logger.new STDERR
  @@cls_logger.progname = "LoggerTest"

  def init_logger
    if @logger == nil
      @logger = Logger.new STDOUT
    end
  end

  def debug_log(msg)
    init_logger
    @logger.debug msg
  end

  def error_log(msg)
    init_logger
    @logger.error do
      msg + "!"
    end
  end

  def fatal_log(msg)
    init_logger
    @logger.fatal msg
  end

  def warn_log(msg)
    init_logger
    @logger.warn msg
  end

  def unknown_log(msg)
    init_logger
    @logger.unknown("unknown prog") { msg }
  end

  def info_log(msg)
    init_logger
    @logger.info do
      if msg.size > 100
        msg[0..91] + "..." + msg[-5..msg.size]
      else
        msg
      end
    end
  end

  def push_log(msg)
    logger = Logger.new STDERR
    logger_alias = logger
    logger_alias << ("test message: " + msg)
  end

  def add_log(msg)
    @@cls_logger.add(Logger::INFO) { "block" }
    # Includes both progname and block return if 'message' is 'nil'
    @@cls_logger.add(Logger::INFO, nil, "progname1") { "block" }

    # block return value is ignored if `message` is specified
    @@cls_logger.add(Logger::WARN, "message1") { "not logged" }
    @@cls_logger.add(Logger::WARN, "message2", "progname2") { "not logged" }
  end

  def log_log(msg)
    @@cls_logger.log(Logger::INFO) { "block" }
    # Includes both progname and block return if 'message' is 'nil'
    @@cls_logger.log(Logger::INFO, nil, "progname1") { "block" }

    # block return value is ignored if `message` is specified
    @@cls_logger.log(Logger::WARN, "message1") { "not logged" }
    @@cls_logger.log(Logger::WARN, "message2", "progname2") { "not logged" }
  end
end
