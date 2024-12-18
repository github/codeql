module Utils 
    def download(path)
        # using an API that doesn't interpret the path as a shell command
        system("wget", path) # OK
    end
end