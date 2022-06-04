class TestController < ActionController::Base
    def unsafe_zlib_unzip
        Zlib::Inflate.inflate(params[:fname])
    end

    def safe_zlib_unzip
        Zlib::Inflate.inflate("testfile.gz")
    end


    DECOMPRESSION_LIB = Zlib
    def unsafe_zlib_unzip_const
        DECOMPRESSION_LIB::Inflate.inflate(params[:fname])
    end

    def unsafe_zlib_unzip
        Zip::File.open(params[:fname]) do |zip_file|
            zip_file.each do |entry|
                entry.extract(entry.name)
            end
        end
    end

    def safe_zlib_unzip
        Zip::Entry.extract("testfile.gz")
    end

    def sanitized_zlib_unzip
        fname = params[:fname]
        if fname == "safe_file.gz"
            Zlib::Inflate.inflate(fname)
        end
    end

    def sanitized_array_zlib_unzip
        fname = params[:fname]
        if ["safe_file1.gz", "safe_file2.gz"].include? fname
            Zlib::Inflate.inflate(fname)
        end
    end

end