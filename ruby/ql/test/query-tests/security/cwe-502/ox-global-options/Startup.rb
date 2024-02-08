require "ox"

# Set the default mode for the Ox library to use the :object mode, which makes
# Ox.load unsafe for untrusted data.
Ox.default_options = { :mode => :object }