class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group
end

class Admin < User
end

class FooController < ApplicationController

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
