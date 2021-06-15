class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group
end

class Admin < User
end

class FooController < ActionController::Base

  MAX_USER_ID = 100_000

  # A string tainted by user input is inserted into an SQL query
  def some_request_handler
    # SELECT AVG(#{params[:column]}) FROM "users"
    User.calculate(:average, params[:column])

    # DELETE FROM "users" WHERE (id = #{params[:id]})
    User.delete_all("id = #{params[:id]}")

    # SELECT "users".* FROM "users" WHERE (id = #{params[:id]})
    User.destroy_all(["id = #{params[:id]}"])

    # SELECT "users".* FROM "users" WHERE id BETWEEN #{params[:min_id]} AND 100000
    User.where(<<-SQL, MAX_USER_ID)
      id BETWEEN #{params[:min_id]} AND ?
    SQL

    UserGroup.joins(:users).where("user.id = #{params[:id]}")
  end
end


class BarController < ApplicationController

  def some_other_request_handler
    ps = params
    # TODO: we don't pick up on this indirect params field reference
    uid = ps[:id]

    # DELETE FROM "users" WHERE (id = #{uid})
    User.delete_all("id = " + uid)
  end

end

class BazController < BarController
end
