ActionCable::Connection::TaggedLoggerProxy.new(logger)

class MyChannel < ActionCable::Channel::Base
	# An RPC endpoint without the optional data parm, so no remote flow source.
	def foo
	end

	# An RPC endpoint including the optional data parm, which is a remote flow source.
	def bar(data)
	end
end