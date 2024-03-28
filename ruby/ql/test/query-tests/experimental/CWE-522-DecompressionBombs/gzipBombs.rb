require 'zlib'

class TestController < ActionController::Base
  gzip_path = params[:path]

  Zlib::GzipReader.open(gzip_path).read
  Zlib::GzipReader.open(gzip_path) do |uncompressedfile|
    puts uncompressedfile.read
  end
  Zlib::GzipReader.open(gzip_path) do |uncompressedfile|
    uncompressedfile.each do |entry|
      puts entry
    end
  end
  uncompressedfile = Zlib::GzipReader.open(gzip_path)
  uncompressedfile.each do |entry|
    puts entry
  end

  Zlib::GzipReader.new(File.open(gzip_path, 'rb')).read
  Zlib::GzipReader.new(File.open(gzip_path, 'rb')).each do |entry|
    puts entry
  end

  Zlib::GzipReader.zcat(open(gzip_path))
end

