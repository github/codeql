class UsersController < ActionController::Base
  def example_zlib_inflate
    MAX_ALLOWED_CHUNK_SIZE = 256
    MAX_ALLOWED_TOTAL_SIZE = 1024

    user_data = params[:data]
    output = []
    outsize = 0

    Zlib::Inflate.inflate(user_data) { |chunk|
      outsize += chunk.size
      if chunk.size < MAX_ALLOWED_CHUNK_SIZE && outsize < MAX_ALLOWED_TOTAL_SIZE
        output << chunk
      end
    }
  end
end