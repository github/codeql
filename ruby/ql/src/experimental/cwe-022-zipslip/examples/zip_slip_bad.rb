class FilesController < ActionController::Base
  def zipFileUnsafe
    path = params[:path]
    Zip::File.open(path).each do |entry|
      File.open(entry.name, "wb") do |os|
        entry.read
      end
    end
  end

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
end
