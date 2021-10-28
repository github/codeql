require "oj"

# Set the default mode for the Oj library to use the :compat mode, which makes
# Oj.load safe for untrusted data.
Oj.default_options = { :mode => :compat }