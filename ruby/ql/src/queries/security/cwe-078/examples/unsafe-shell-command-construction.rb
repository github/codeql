module Utils 
    def download(path)
        system("wget #{path}") # NOT OK
    end
end