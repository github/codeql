class TestController < ActionController::Base
    def unsafe_zlib_unzip
        Zlib::Inflate.inflate(params[:path])
    end

    def safe_zlib_unzip
        Zlib::Inflate.inflate("testfile.gz")
    end

    def sanitized_zlib_unzip
        if params[:path].in ["safe_file1.gz", "safe_file2.gz"]
            Zlib::Inflate.inflate(params[:path])
        end
    end

end