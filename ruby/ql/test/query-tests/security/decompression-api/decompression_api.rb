class TestController < ActionController::Base
    def unsafe_unzip
        TestModel::unzip(params[:path])
    end
end

class TestModel
    def unzip(filename)
        Zlib::Inflate.inflate(filename)
    end
end