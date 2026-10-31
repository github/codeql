require 'zlib'

class TestController < ActionController::Base
  gzip_path = params[:path] # $ Source

  Zlib::GzipReader.open(gzip_path).read # $ Alert
  Zlib::GzipReader.open(gzip_path) do |uncompressedfile| # $ Alert
    puts uncompressedfile.read
  end
  Zlib::GzipReader.open(gzip_path) do |uncompressedfile| # $ Alert
    uncompressedfile.each do |entry|
      puts entry
    end
  end
  uncompressedfile = Zlib::GzipReader.open(gzip_path) # $ Alert
  uncompressedfile.each do |entry|
    puts entry
  end

  Zlib::GzipReader.new(File.open(gzip_path, 'rb')).read # $ Alert
  Zlib::GzipReader.new(File.open(gzip_path, 'rb')).each do |entry| # $ Alert
    puts entry
  end

  Zlib::GzipReader.zcat(open(gzip_path)) # $ Alert
end

