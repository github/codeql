class User < ActiveRecord::Base
end

def m1
  gid = User.find(1).to_global_id
  GlobalID::Locator.locate gid
end

def m2
  gid = User.find(1).to_gid
  GlobalID::Locator.locate gid
end

def m3
  sgid = User.find(1).to_signed_global_id
  GlobalID::Locator.locate_signed sgid
end

def m4
  sgid = User.find(1).to_sgid
  GlobalID::Locator.locate_signed sgid
end

def m5
  gids = User.all.map(&:to_gid)
  GlobalID::Locator.locate_many gids
end

def m6
  sgids = User.all.map(&:to_sgid)
  GlobalID::Locator.locate_many_signed sgids
end

def m7
  gidp = User.find(1).to_gid_param
  gid = GlobalID.parse gidp
  GlobalID.find gid
end

def m8
  sgidp = User.find(1).to_sgid_param
  sgid = SignedGlobalID.parse sgidp
  SignedGlobalID.find sgid
end

class Person
  include GlobalID::Identification

  def self.find(id)
    # implementation goes here
  end
end

def m9
  p = Person.find(1)
  gid = p.to_gid
  GlobalID.find gid
end

def m10
  p = Person.find(1)
  gid = p.to_global_id
  GlobalID.find gid
end

def m11
  p = Person.find(1)
  gidp = p.to_gid_param
  gid = GlobalID.parse gidp
  GlobalID::Locator.locate gid
end

def m12
  p = Person.find(1)
  sgid = p.to_sgid
  SignedGlobalID.find sgid
end

def m10
  p = Person.find(1)
  sgid = p.to_signed_global_id
  SignedGlobalID.find sgid
end

def m11
  p = Person.find(1)
  sgidp = p.to_sgid_param
  sgid = SignedGlobalID.parse sgidp
  GlobalID::Locator.locate_signed sgid
end
