class TestContoller < ActionController::Base
  
  # this is vulnerable
  def upload
    untar params[:file], params[:filename] # $ Source=upload
  end

  # this is vulnerable
  def unpload_zip
    unzip params[:file] # $ Source=upload_zip
  end

  # this is vulnerable
  def create_new_zip
    zip params[:filename], files # $ Source=create_new_zip
  end

  # these are not vulnerable because of the string compare sanitizer
  def safe_upload_string_compare
    filename = params[:filename]
    if filename == "safefile.tar"
      untar params[:file], filename
    end
  end

  def safe_upload_zip_string_compare
    filename = params[:filename]
    if filename == "safefile.zip"
      unzip filename
    end
  end

  # these are not vulnerable beacuse of the string array compare sanitizer
  def safe_upload_string_array_compare
    filename = params[:filename]
    if ["safefile1.tar", "safefile2.tar"].include? filename
      untar params[:file], filename
    end
  end

  def safe_upload_zip_string_array_compare
    filename = params[:filename]
    if ["safefile1.zip", "safefile2.zip"].include? filename
      unzip filename
    end
  end

  # these are our two sinks
  def untar(io, destination)
    Gem::Package::TarReader.new io do |tar|
      tar.each do |tarfile|
        destination_file = File.join destination, tarfile.full_name
        
        if tarfile.directory?
          FileUtils.mkdir_p destination_file
        else
          destination_directory = File.dirname(destination_file)
          FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
          File.open destination_file, "wb" do |f| # $ Alert=upload
            f.print tarfile.read
          end
        end
      end
    end
  end

  def unzip(file)
    Zip::File.open(file) do |zip_file| # $ Alert=upload_zip
      zip_file.each do |entry|
        entry.extract
      end
    end
  end

  def zip(filename, files = [])
    Zip::File.new(filename) do |zf| # $ Alert=create_new_zip
      files.each do |f|
        zf.add f
      end
    end
  end
end