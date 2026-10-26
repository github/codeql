class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group

  def self.authenticate(name, pass)
    find(:first, :conditions => "name='#{name}' and pass='#{pass}'")
  end

  def self.from(user_group_id)
    UserGroup.find_by(id: user_group_id).users
  end

  def exec(q)
    connection.create(q)
    connection.delete(q)
    connection.exec_query(q)
    connection.exec_insert(q)
    connection.exec_delete(q)
    connection.exec_update(q)
    connection.execute(q)
    connection.insert(q)
    connection.select_all(q)
    connection.select_one(q)
    connection.select_rows(q)
    connection.select_value(q)
    connection.select_values(q)
    connection.update(q)
  end
end

class Admin < User
  def self.delete_by(condition = nil)
    destroy_by(condition)
  end
end

class FooController < ActionController::Base

  MAX_USER_ID = 100_000

  def some_request_handler
    User.calculate(:average, params[:column])
    User.delete_by("id = '#{params[:id]}'")
    User.destroy_by(["id = '#{params[:id]}'"])
    User.where(<<-SQL, MAX_USER_ID)
      id BETWEEN '#{params[:min_id]}' AND ?
    SQL
    User.where.not("user.id = '#{params[:id]}'")
    User.authenticate(params[:name], params[:pass])
    User.find_by_name("alice")
    User.not_a_find_by_method("bob")
  end
end

class BarController < ApplicationController
  def some_other_request_handler
    ps = params
    uid = ps[:id]
    uidEq = "= '#{uid}'"
    User.delete_by("id " + uidEq)
  end

  def safe_paths
    dir = params[:order]
    dir = "DESC" unless dir == "ASC"
    User.order("name #{dir}")

    name = params[:user_name]
    if %w(alice bob charlie).include? name
      User.find_by("username = #{name}")
    end

    name = params[:user_name]
    User.find_by(user_name: name)

    User.find(params[:user_group])
  end
end

class BazController < BarController
  def yet_another_handler
    Admin.delete_by(params[:admin_condition])
  end

  def create1
    Admin.create(params)
  end

  def create2
    Admin.create(name: params[:name], password: params[:password])
  end

  def create3
    Admin.create({name: params[:name], password: params[:password]})
  end

  def create4
    Admin.create
  end

  def update1
    Admin.update(1, params)
  end

  def update2
    Admin.update(1, name: params[:name], password: params[:password])
  end

  def update3
    Admin.update(1, {name: params[:name], password: params[:password]})
  end
end

class AnnotatedController < ActionController::Base
  def index
    users = User.annotate("this is a safe annotation")
  end

  def unsafe_action
    users = User.annotate("this is an unsafe annotation:#{params[:comment]}")
  end
end
