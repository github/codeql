require 'rack'
require 'rack/handler/puma'
handler = Rack::Handler::Puma

class InstanceApp
  def call(env)
    status = 200
    headers = {}
    body = ["instance app"]
    resp = [status, headers, body]
    resp
  end
end

class ClassApp
  def self.call(env)
    [200, {}, ["class app"]]
  end
end

lambda_app = ->(env) { [200, {}, ["lambda app"]] }

proc_app = Proc.new { |env| [200, {}, ["proc app"]] }

handler.run InstanceApp.new
handler.run ClassApp
handler.run lambda_app
handler.run proc_app
