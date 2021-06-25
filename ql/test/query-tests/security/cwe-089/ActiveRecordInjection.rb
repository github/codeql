class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group

  def self.authenticate(name, pass)
    # BAD: possible untrusted input interpolated into SQL fragment
    find(:first, :conditions => "name='#{name}' and pass='#{pass}'")
  end
end

class Admin < User
end

class FooController < ActionController::Base

  MAX_USER_ID = 100_000

  # A string tainted by user input is inserted into an SQL query
  def some_request_handler
    # BAD: executes `SELECT AVG(#{params[:column]}) FROM "users"`
    # where `params[:column]` is unsanitized
    User.calculate(:average, params[:column])

    # BAD: executes `DELETE FROM "users" WHERE (id = '#{params[:id]}')`
    # where `params[:id]` is unsanitized
    User.delete_all("id = '#{params[:id]}'")

    # BAD: executes `SELECT "users".* FROM "users" WHERE (id = '#{params[:id]}')`
    # where `params[:id]` is unsanitized
    User.destroy_all(["id = '#{params[:id]}'"])

    # BAD: executes `SELECT "users".* FROM "users" WHERE id BETWEEN '#{params[:min_id]}' AND 100000`
    # where `params[:min_id]` is unsanitized
    User.where(<<-SQL, MAX_USER_ID)
      id BETWEEN '#{params[:min_id]}' AND ?
    SQL

    # BAD: chained method case
    # executes `SELECT "users".* FROM "users" WHERE (NOT (user_id = 'params[:id]'))`
    # where `params[:id]` is unsanitized
    User.where.not("user.id = '#{params[:id]}'")

    User.authenticate(params[:name], params[:pass])
  end
end


class BarController < ApplicationController

  def some_other_request_handler
    ps = params
    uid = ps[:id]
    uidEq = "= '#{uid}'"

    # BAD: executes `DELETE FROM "users" WHERE (id = #{uid})`
    # where `uid` is unsantized
    User.delete_all("id " + uidEq)
  end

  def sanitized_paths

    dir = params[:order]
    # GOOD: barrier guard prevents taint flow
    dir = "DESC" unless dir == "ASC"
    User.order("name #{dir}")

    name = params[:user_name]
    # GOOD: barrier guard prevents taint flow
    if %w(alice bob charlie).include? name
      User.find_by("username = #{name}")
    end

    name = params[:user_name]
    # GOOD: hash arguments are sanitized by ActiveRecord
    User.find_by(user_name: name)
  end
end

class BazController < BarController
end
