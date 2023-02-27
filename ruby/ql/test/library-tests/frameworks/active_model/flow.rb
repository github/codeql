class User < ActiveRecord::Base
  include ActiveModel::API
  
  attr_reader :name
  attr_reader :age
end

user = User.new
user.name = source "a"

h = user.serializable_hash
sink h["name"] # $ hasValueFlow=a
sink h["age"]
sink h["unknown_field"]

user2 = User.new
user2.age = source "b"

h2 = user2.serializable_hash
sink h2["age"] # $ hasValueFlow=b
sink h2["name"]
sink h2["unknown_field"]