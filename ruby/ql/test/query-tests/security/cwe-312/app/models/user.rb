class User < ActiveRecord::Base
  def set_password_1
    new_password = "06c38c6a8a9c11a9d3b209a3193047b4" # $ Source[rb/clear-text-storage-sensitive-data]
    # BAD: directly storing a potential cleartext password to a field
    self.update(password: new_password) # $ Alert[rb/clear-text-storage-sensitive-data]
  end

  def set_password_2
    new_password = "52652fb5c709fb6b9b5a0194af7c6067" # $ Source[rb/clear-text-storage-sensitive-data]
    # BAD: directly storing a potential cleartext password to a field
    update(password: new_password) # $ Alert[rb/clear-text-storage-sensitive-data]
  end

  def set_password_3
    new_password = "f982bf2531c149a8a1444a951b12e830" # $ Source[rb/clear-text-storage-sensitive-data]
    # BAD: directly assigning a potential cleartext password to a field
    self.password = new_password # $ Alert[rb/clear-text-storage-sensitive-data]
    self.save
  end
end
