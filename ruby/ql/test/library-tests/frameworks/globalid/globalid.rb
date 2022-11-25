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
