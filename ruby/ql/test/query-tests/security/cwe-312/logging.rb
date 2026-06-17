stdout_logger = Logger.new STDOUT

password = "043697b96909e03ca907599d6420555f" # $ Source[rb/clear-text-logging-sensitive-data]

# BAD: password logged as plaintext
stdout_logger.info password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.debug password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.error password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.fatal password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.unknown password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.warn password # $ Alert[rb/clear-text-logging-sensitive-data]

# BAD: password logged as plaintext
stdout_logger.add Logger::WARN, password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.add Logger::WARN, "message", password # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.log Logger::WARN, password # $ Alert[rb/clear-text-logging-sensitive-data]

# BAD: password logged as plaintext
stdout_logger << "pw: #{password}" # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: sensitive data in the progname will taint subsequent logging calls
stdout_logger.progname = password # $ Alert[rb/clear-text-logging-sensitive-data]

hsh1 = { password: "aec5058e61f7f122998b1a30ee2c66b6" } # $ Source[rb/clear-text-logging-sensitive-data]
hsh2 = {}
# GOOD: no backwards flow
stdout_logger.info hsh2[:password]
hsh2[:password] = "beeda625d7306b45784d91ea0336e201" # $ Source[rb/clear-text-logging-sensitive-data]
hsh3 = hsh2

# BAD: password logged as plaintext
stdout_logger.info hsh1[:password] # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.info hsh2[:password] # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password logged as plaintext
stdout_logger.info hsh3[:password] # $ Alert[rb/clear-text-logging-sensitive-data]
# GOOD: not a password
stdout_logger.info hsh1[:foo]

password_masked_sub = "ca497451f5e883662fb1a37bc9ec7838"
password_masked_sub_ex = "ca497451f5e883662fb1a37bc9ec7838"
password_masked_gsub = "a7e3747b19930d4f4b8181047194832f"
password_masked_gsub_ex = "a7e3747b19930d4f4b8181047194832f"
password_masked_sub = password_masked_sub.sub(/.+/, "[password]")
password_masked_sub_ex.sub!(/.+/, "[password]")
password_masked_gsub = password_masked_gsub.gsub(/./, "*")
password_masked_gsub_ex.gsub!(/./, "*")

# GOOD: password is effectively masked before logging
stdout_logger.info password_masked_sub
# GOOD: password is effectively masked before logging
stdout_logger.info password_masked_gsub
# GOOD: password is effectively masked before logging
stdout_logger.info password_masked_sub_ex
# GOOD: password is effectively masked before logging
stdout_logger.info password_masked_gsub_ex

password_masked_ineffective_sub = "ca497451f5e883662fb1a37bc9ec7838" # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_sub_ex = "ca497451f5e883662fb1a37bc9ec7838" # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_gsub = "a7e3747b19930d4f4b8181047194832f" # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_gsub_ex = "a7e3747b19930d4f4b8181047194832f" # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_sub = password_masked_ineffective_sub.sub(/./, "[password]") # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_sub_ex.sub!(/./, "[password]")
password_masked_ineffective_gsub = password_masked_ineffective_gsub.gsub(/[A-Z]/, "*") # $ Source[rb/clear-text-logging-sensitive-data]
password_masked_ineffective_gsub_ex.gsub!(/[A-Z]/, "*")

# BAD: password masked ineffectively
stdout_logger.info password_masked_ineffective_sub # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password masked ineffectively
stdout_logger.info password_masked_ineffective_gsub # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password masked ineffectively
stdout_logger.info password_masked_ineffective_sub_ex # $ Alert[rb/clear-text-logging-sensitive-data]
# BAD: password masked ineffectively
stdout_logger.info password_masked_ineffective_gsub_ex # $ Alert[rb/clear-text-logging-sensitive-data]

def foo(password, logger)
  # BAD: password logged as plaintext
  logger.info password # $ Alert[rb/clear-text-logging-sensitive-data]
end

password_arg = "65f2950df2f0e2c38d7ba2ccca767291" # $ Source[rb/clear-text-logging-sensitive-data]
foo(password_arg, stdout_logger)
foo("65f2950df2f0e2c38d7ba2ccca767292", stdout_logger)

def redact(password)
  "***"
end

password_r1 = redact("65f2950df2f0e2c38d7ba2ccca767291")
password_r2 = password_r1
# GOOD: password_r2 has been redacted
stdout_logger.info password_r2
