class Person < ActiveResource::Base
  self.site = "https://api.example.com"
end

alice = Person.new(name: "Alice")
alice.save

alice = Person.find(1)
alice.address = "123 Main Street"
alice.save

alice.destroy

# Custom REST methods

Person.new(name: "Bob").post(:register)
alice.put(:promote)
Person.get(:positions)
alice.delete(:fire)

# Collections

people = Person.all
people = Person.find(:all)

alice = people.first
alice.save

class Post < ActiveResource::Base
  self.site = "http://api.insecure.com"
end
