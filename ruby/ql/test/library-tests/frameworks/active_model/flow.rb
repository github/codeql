class User < ActiveRecord::Base
  include ActiveModel::API
  
  attr_reader :name
end

user = User.new
user.name = source "a"

h = user.serializable_hash
sink h["name"] # $ hasValueFlow=a