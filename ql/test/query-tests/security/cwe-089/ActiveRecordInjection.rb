class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group

  def self.authenticate(name, pass)
    # BAD: possible untrusted input interpolated into SQL fragment
    find(:first, :conditions => "name='#{name}' and pass='#{pass}'")
  end

  def self.from(user_group_id)
    # GOOD: `find_by` with hash argument
    UserGroup.find_by(id: user_group_id).users
  end
end

class Admin < User
  def self.delete_all(condition = nil)
    # BAD: `delete_all` overrides an ActiveRecord method, but doesn't perform
    # any validation before passing its arguments on to another ActiveRecord method
    destroy_all(condition)
  end
end

class FooController < ActionController::Base

  MAX_USER_ID = 100_000

  # A string tainted by user input is inserted into an SQL query
  def some_request_handler
    # BAD: executes `SELECT AVG(#{params[:column]}) FROM "users"`
    # where `params[:column]` is unsanitized
    User.calculate(:average, params[:column])

    # BAD: executes `SELECT MAX(#{params[:column]}) FROM "users"`
    # where `params[:column]` is unsanitized
    User.maximum(params[:column])

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

  def safe_paths
    dir = params[:order]
    # GOOD: barrier guard prevents taint flow
    if dir == "ASC"
      User.order("name #{dir}")
    else
      dir = "DESC"
      User.order("name #{dir}")
    end
    # TODO: a more idiomatic form of this guard is the following:
    #     dir = "DESC" unless dir == "ASC"
    # but our taint tracking can't (yet) handle that properly

    name = params[:user_name]
    # GOOD: barrier guard prevents taint flow
    if %w(alice bob charlie).include? name
      User.find_by("username = #{name}")
    end

    name = params[:user_name]
    # GOOD: hash arguments are sanitized by ActiveRecord
    User.find_by(user_name: name)

    # OK: `find` method is overridden in `User`
    User.find(params[:user_group])
  end
end

class BazController < BarController
  def yet_another_handler
    Admin.delete_all(params[:admin_condition])
  end
end
