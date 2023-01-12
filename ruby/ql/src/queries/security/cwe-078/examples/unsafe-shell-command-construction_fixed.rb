module Utils 
    def download(path)
        # using an array to call `system` is safe
        system("wget", path) # OK
    end
end