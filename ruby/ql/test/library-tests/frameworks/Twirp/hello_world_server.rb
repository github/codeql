require 'rack'
require 'webrick'

require_relative 'hello_world/service_twirp.rb'

class HelloWorldHandler
  # test: request
  def hello(req, env)
    puts ">> Hello #{req.name}"
    {message: "Hello #{req.name}"}
  end
end

class FakeHelloWorldHandler
  # test: !request
  def hello(req, env)
    puts ">> Hello #{req.name}"
    {message: "Hello #{req.name}"}
  end
end

handler = HelloWorldHandler.new()
# test: serviceInstantiation
service = Example::HelloWorld::HelloWorldService.new(handler)

path_prefix = "/twirp/" + service.full_name
server = WEBrick::HTTPServer.new(Port: 8080)
server.mount path_prefix, Rack::Handler::WEBrick, service
server.start

class StaticHandler
  def self.hello(req, env)
    puts ">> Hello #{req.name}"
    {message: "Hello #{req.name}"}
  end
end

Example::HelloWorld::HelloWorldService.new(StaticHandler)
