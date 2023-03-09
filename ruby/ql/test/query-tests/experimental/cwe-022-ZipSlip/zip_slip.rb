require 'zip'

class TestController < ActionController::Base
  # BAD
  def tarReaderUnsafe
    path = params[:path]
    file_stream = IO.new(IO.sysopen(path))
    tarfile = Gem::Package::TarReader.new(file_stream)
    tarfile.each do |entry|
      ::File.open(entry.full_name, "wb") do |os|
        entry.read
      end
    end
  end

  # BAD
  def tarReaderBlockUnsafe
    path = params[:path]
    file_stream = IO.new(IO.sysopen(path))
    Gem::Package::TarReader.new(file_stream) do |tarfile|
      tarfile.each_entry do |entry|
        ::File.open(entry.full_name, "wb") do |os|
          entry.read
        end
      end
    end
  end
  
  # GOOD
  def tarReadeSanitizedExpandPath
    path = params[:path]
    file_stream = IO.new(IO.sysopen(path))
    tarfile = Gem::Package::TarReader.new(file_stream)
    tarfile.each do |entry|
      entry_path = entry.full_name
      next if !File.expand_path(entry_path).start_with?("/safepath/")
      ::File.open(entry_path, "wb") do |os|
        entry.read
      end
    end
  end
  
  # BAD
  def zipFileUnsafe
    path = params[:path]
    Zip::File.open(path).each do |entry|
      File.open(entry.name, "wb") do |os|
        entry.read
      end
    end
  end

  # BAD
  def zipFileBlockUnsafe
    path = params[:path]
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        File.open(entry.name, "wb") do |os|
          entry.read
        end
      end
    end
  end

  # GOOD
  def zipFileBlockSafeHardcodedPath
    path = '/safepath.zip'
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        File.open(entry.name, "wb") do |os|
          entry.read
        end
      end
    end
  end
  
  # GOOD
  def zipFileSanitizedConstCompare
    path = params[:path]
    Zip::File.open(path).each do |entry|
      entry_path = entry.name
      raise ExtractFailed if entry_path != "/safepath"
      File.open(entry_path, "wb") do |os|
        entry.read
      end
    end
  end
  
  def get_compressed_file_stream(compressed_file_path)
    gzip = Zlib::GzipReader.open(compressed_file_path)
    yield(gzip)
  end
  
  # BAD
  def gzipReaderUnsafe
    path = params[:path]
    get_compressed_file_stream(path) do |compressed_file|
      compressed_file.each do |entry|
        entry_path = entry.full_name
        ::File.open(entry_path, 'wb') do |os|
          entry.read
        end
      end
    end
  end

  # GOOD
  def gzipReaderSafeConstPath
    path = "/safe.zip"
    zlib = Zlib::GzipReader.open(path)
    zlib.each do |entry|
      entry_path = entry.full_name
      ::File.open(entry_path, 'wb') do |os|
        entry.read
      end
    end
  end

  # BAD
  def gzipReaderUnsafeNewInstance
    path = params[:path]
    File.open(path, 'rb') do |f|
      gz = Zlib::GzipReader.new(f)
      gz.each do |entry|
        entry_path = entry.full_name
        ::File.open(entry_path, 'wb') do |os|
          entry.read
        end
      end
    end
  end

end
