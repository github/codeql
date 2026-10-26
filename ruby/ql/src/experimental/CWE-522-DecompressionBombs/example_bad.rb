# "Note that if you use the lower level Zip::InputStream interface, rubyzip does not check the entry sizes"
zip_stream = Zip::InputStream.new(File.open('file.zip'))
while entry = zip_stream.get_next_entry
  # All required operations on `entry` go here.
end