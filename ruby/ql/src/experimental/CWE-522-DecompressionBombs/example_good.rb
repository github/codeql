MAX_FILE_SIZE = 10 * 1024**2 # 10MiB
MAX_FILES = 100
Zip::File.open('foo.zip') do |zip_file|
  num_files = 0
  zip_file.each do |entry|
    num_files += 1 if entry.file?
    raise 'Too many extracted files' if num_files > MAX_FILES
    raise 'File too large when extracted' if entry.size > MAX_FILE_SIZE
    entry.extract
  end
end