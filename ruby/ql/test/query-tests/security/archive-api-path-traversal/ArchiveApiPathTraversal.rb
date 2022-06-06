class TestContoller < ActionController::Base
  
  def upload
    untar params[:file], params[:filename]
  end

  def unpload_zip
    unzip params[:file]
  end

  def untar(io, destination)
    Gem::Package::TarReader.new io do |tar|
      tar.each do |tarfile|
        destination_file = File.join destination, tarfile.full_name
        
        if tarfile.directory?
          FileUtils.mkdir_p destination_file
        else
          destination_directory = File.dirname(destination_file)
          FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
          File.open destination_file, "wb" do |f|
            f.print tarfile.read
          end
        end
      end
    end
  end

  def unzip(file)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |entry|
        entry.extract
      end
    end
  end
end