class FilesController < ActionController::Base
  def zipFileSafe
    path = params[:path]
    Zip::File.open(path).each do |entry|
      entry_path = entry.name
      next if !File.expand_path(entry_path).start_with?('/safepath/')
      File.open(entry_path, "wb") do |os|
        entry.read
      end
    end
  end

  def tarReaderSafe
    path = params[:path]
    file_stream = IO.new(IO.sysopen(path))
    tarfile = Gem::Package::TarReader.new(file_stream)
    tarfile.each do |entry|
      entry_path = entry.full_name
      raise ExtractFailed if entry_path != "/safepath"
      ::File.open(entry_path, "wb") do |os|
        entry.read
      end
    end
  end  
end
