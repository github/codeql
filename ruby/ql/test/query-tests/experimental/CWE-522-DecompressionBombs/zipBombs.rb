require 'zip'

class TestController < ActionController::Base
  zipfile_path = params[:path] # $ Source

  Zip::InputStream.open(zipfile_path) do |input|
    while (entry = input.get_next_entry)
      puts :file_name, entry.name
      input
    end
  end # $ Alert
  Zip::InputStream.open(zipfile_path) do |input|
    input.read
  end # $ Alert
  input = Zip::InputStream.open(zipfile_path) # $ Alert

  Zip::File.open(zipfile_path).read "10GB" # $ Alert
  Zip::File.open(zipfile_path).extract "10GB", "./" # $ Alert

  Zip::File.open(zipfile_path) do |zip_file|
    # Handle entries one by one
    zip_file.each do |entry|
      puts "Extracting #{entry.name}"
      raise 'File too large when extracted' if entry.size > MAX_SIZE
      # Extract to file or directory based on name in the archive
      entry.extract
      # Read into memory
      entry.get_input_stream.read # $ Alert
    end
  end

  zip_file = Zip::File.open(zipfile_path)
  zip_file.each do |entry|
    entry.extract # $ Alert
    entry.get_input_stream.read # $ Alert
  end

  # Find specific entry
  Zip::File.open(zipfile_path) do |zip_file|
    zip_file.glob('*.xml').each do |entry|
      zip_file.read(entry.name) # $ Alert
      entry.extract # $ Alert
    end
    entry = zip_file.glob('*.csv').first
    raise 'File too large when extracted' if entry.size > MAX_SIZE
    puts entry.get_input_stream.read # $ Alert
  end

  zip_file = Zip::File.open(zipfile_path)
  entry = zip_file.glob('*.csv')
  puts entry.get_input_stream.read # $ Alert

  zip_file = Zip::File.open(zipfile_path)
  zip_file.glob('*') do |entry|
    entry.get_input_stream.read # $ Alert
  end
end
