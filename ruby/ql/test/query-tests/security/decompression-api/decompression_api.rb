class TestController < ActionController::Base
    # this should get picked up
    def unsafe_zlib_unzip
        path = params[:file]
        Zlib::Inflate.inflate(path)
    end

    # this should not get picked up
    def safe_zlib_unzip
        Zlib::Inflate.inflate(file)
    end

    # this should get picked up
    def unsafe_zlib_unzip
        Zip::File.open_buffer(params[:file])
    end

    # this should not get picked up
    def safe_zlib_unzip
        Zip::File.open_buffer(file)
    end
end