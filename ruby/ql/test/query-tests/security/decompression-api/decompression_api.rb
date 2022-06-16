class TestController < ActionController::Base
    def unsafe_zlib_unzip
        Zlib::Inflate.inflate(params[:file])
    end

    def safe_zlib_unzip
        Zlib::Inflate.inflate(file)
    end


    DECOMPRESSION_LIB = Zlib
    def unsafe_zlib_unzip_const
        DECOMPRESSION_LIB::Inflate.inflate(params[:file])
    end
end