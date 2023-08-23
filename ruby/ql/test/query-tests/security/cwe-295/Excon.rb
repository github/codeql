require "excon"

def method1
  # BAD
  Excon.defaults[:ssl_verify_peer] = false
  Excon.get("http://example.com/")
end

def method2
  # BAD
  Excon.ssl_verify_peer = false
  Excon.get("http://example.com/")
end

def method3(secure)
  # BAD
  Excon.defaults[:ssl_verify_peer] = (secure ? true : false)
  Excon.get("http://example.com/")
end

def method4
  # BAD
  conn = Excon::Connection.new("http://example.com/", ssl_verify_peer: false)
  conn.get
end

def method5
  # BAD
  Excon.ssl_verify_peer = true
  Excon.new("http://example.com/", ssl_verify_peer: false).get
end

def method6
  # GOOD
  Excon.defaults[:ssl_verify_peer] = true
  Excon.get("http://example.com/")
end

def method7
  # GOOD
  Excon.ssl_verify_peer = true
  Excon.get("http://example.com/")
end

def method8
  # GOOD
  Excon.defaults[:ssl_verify_peer] = false
  Excon.new("http://example.com/", ssl_verify_peer: true)
end

# Regression test for excon

class Excon
  def self.new(params)
    Excon::Connection.new(params)
  end
end

def method9
  # GOOD: connection is not used
  Excon.new("foo", ssl_verify_peer: false)
end

def method10
  # GOOD
  connection = Excon.new("foo")
  connection.get("bar")
end