module Users
  class UsersController < ApplicationController
    def create_or_modify
      # CreateLikeCall
      User.create!(name: "U1", uid: get_uid)
      User.create(name: "U2")
      User.insert({name: "U3"})

      # UpdateLikeClassMethodCall
      User.update(4, name: "U4")
      User.update!([5, 6, 7], [{name: "U5"}, {name: "U6"}, {name: "U7"}])

      # InsertAllLikeCall
      User.insert_all([{name: "U8"}, {name: "U9"}, {name: "U10"}])

      user = User.find(5)

      # UpdateLikeInstanceMethodCall
      user.update(name: "U11")
      user.update_attributes({name: "U12", uid: get_uid})

      # UpdateAttributeCall
      user.update_attribute("name", "U13")

      # AssignAttributeCall
      user.name = "U14"
      user.save
    end

    def get_uid
      User.last.id + 1
    end
  end
end
