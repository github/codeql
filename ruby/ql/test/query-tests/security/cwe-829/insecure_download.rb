require "excon"

def foo
    def download_tools(installer)
        Excon.get(installer[:url]) # $ MISSING: Alert (requires hash flow)
    end

    constants = {
        build_tools: {
            installer_url: 'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe'
        }
    }
    def get_build_tools_installer_path
        build_tools = constants[:build_tools]
        { url: build_tools[:installer_url] }
    end

    download_tools get_build_tools_installer_path
end


def bar
    Excon.get('http://www.google.com') # GOOD

    Excon.get("https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe") # GOOD

    Excon.get("http://example.org/unsafe.APK") # $ Alert
end

def baz
    url = "http://example.org/unsafe.APK" # $ Source

    Excon.get(url) # $ Alert
end

def test
    File.open("foo.exe").write(Excon.get("http://example.org/unsafe").body) # $ Alert

    File.open("foo.safe").write(Excon.get("http://example.org/unsafe").body) # GOOD

    File.write("foo.exe", Excon.get("http://example.org/unsafe").body) # $ Alert

    resp = Excon.get("http://example.org/unsafe.unknown") # $ Alert
    file = File.open("unsafe.exe", "w")
    file.write(resp.body)

    resp = Excon.get("http://example.org/unsafe.unknown")
    file = File.open("foo.safe", "w")
    file.write(resp.body) # GOOD
end

def sh
    script = Net::HTTP.new("http://mydownload.example.org").get("/myscript.sh").body # $ Alert
    system(script)
end
