class UserGroup < ActiveRecord::Base
  has_many :users
end

class User < ApplicationRecord
  belongs_to :user_group

  def self.authenticate(name, pass)
    # BAD: possible untrusted input interpolated into SQL fragment
    find(:first, :conditions => "name='#{name}' and pass='#{pass}'")
    # BAD: interpolation in array argument
    find(:first, conditions: ["name='#{name}' and pass='#{pass}'"])
    # GOOD: using SQL parameters
    find(:first, conditions: ["name = ? and pass = ?", name, pass])
    # BAD: interpolation with flow
    conds = "name=#{name}"
    find(:first, conditions: conds)
  end

  def self.from(user_group_id)
    # GOOD: `find_by` with hash argument
    UserGroup.find_by(id: user_group_id).users
  end
end

class Admin < User
  def self.delete_by(condition = nil)
    # BAD: `delete_by overrides an ActiveRecord method, but doesn't perform
    # any validation before passing its arguments on to another ActiveRecord method
    destroy_by(condition)
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
    User.delete_by("id = '#{params[:id]}'")

    # BAD: executes `DELETE FROM "users" WHERE (id = '#{params[:id]}')`
    # where `params[:id]` is unsanitized
    # (in Rails < 4.0)
    User.delete_all("id = '#{params[:id]}'")

    # BAD: executes `SELECT "users".* FROM "users" WHERE (id = '#{params[:id]}')`
    # where `params[:id]` is unsanitized
    User.destroy_by(["id = '#{params[:id]}'"])

    # BAD: executes `SELECT "users".* FROM "users" WHERE (id = '#{params[:id]}')`
    # where `params[:id]` is unsanitized
    # (in Rails < 4.0)
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

    # BAD: executes `SELECT "users".* FROM "users" WHERE (id = '#{params[:id]}')` LIMIT 1
    # where `params[:id]` is unsanitized
    User.find_or_initialize_by("id = '#{params[:id]}'")

    user = User.first
    # BAD: executes `SELECT "users".* FROM "users" WHERE id = 1 LIMIT 1 #{params[:lock]}`
    # where `params[:lock]` is unsanitized
    user.reload(lock: params[:lock])

    # BAD: executes `SELECT #{params[:column]} FROM "users"`
    # where `params[:column]` is unsanitized
    User.select(params[:column])
    User.reselect(params[:column])

    # BAD: executes `SELECT "users".* FROM "users" WHERE (#{params[:condition]})`
    # where `params[:condition]` is unsanitized
    User.rewhere(params[:condition])

    # BAD: executes `UPDATE "users" SET #{params[:fields]}`
    # where `params[:fields]` is unsanitized
    User.update_all(params[:fields])

    # GOOD -- `update_all` sanitizes its bind variable arguments
    User.find_by(name: params[:user_name])
      .update_all(['name = ?', params[:new_user_name]])

    # BAD -- `update_all` does not sanitize its query (array arg)
    User.find_by(name: params[:user_name])
      .update_all(["name = '#{params[:new_user_name]}'"])

    # BAD -- `update_all` does not sanitize its query (string arg)
    User.find_by(name: params[:user_name])
      .update_all("name = '#{params[:new_user_name]}'")

    User.reorder(params[:direction])

    User.select('a','b', params[:column])
    User.reselect('a','b', params[:column])
    User.order('a ASC', "b #{params[:direction]}")
    User.reorder('a ASC', "b #{params[:direction]}")
    User.group('a', params[:column])
    User.pluck('a', params[:column])
    User.joins(:a, params[:column])

    User.count_by_sql(params[:custom_sql_query])

    # BAD: executes `SELECT users.* FROM #{params[:tab]}`
    # where `params[:tab]` is unsanitized
    User.all.from(params[:tab])
    # BAD: executes `SELECT "users".* FROM (SELECT "users".* FROM "users") #{params[:sq]}
    User.all.from(User.all, params[:sq])
  end
end

class BarController < ApplicationController
  def some_other_request_handler
    ps = params
    uid = ps[:id]
    uidEq = "= '#{uid}'"

    # BAD: executes `DELETE FROM "users" WHERE (id = #{uid})`
    # where `uid` is unsantized
    User.delete_by("id " + uidEq)
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
    Admin.delete_by(params[:admin_condition])
  end
end

class AnnotatedController < ActionController::Base
  def index
    name = params[:user_name]
    # GOOD: string literal arguments not controlled by user are safe for annotations
    users = User.annotate("this is a safe annotation").find_by(user_name: name)
  end

  def unsafe_action
    name = params[:user_name]
    # BAD: user input passed into annotations are vulnerable to SQLi
    users = User.annotate("this is an unsafe annotation:#{params[:comment]}").find_by(user_name: name)
  end
end

# A regression test

class Regression < ActiveRecord::Base
end

class RegressionController < ActionController::Base
  def index
    my_params = permitted_params
    query = "SELECT * FROM users WHERE id = #{my_params[:user_id]}"
    result = Regression.find_by_sql(query)
  end


  def permitted_params
    params.require(:my_key).permit(:id, :user_id, :my_type)
  end

  def show
    ActiveRecord::Base.connection.execute("SELECT * FROM users WHERE id = #{permitted_params[:user_id]}")
    Regression.connection.execute("SELECT * FROM users WHERE id = #{permitted_params[:user_id]}")
  end
end

class User
  scope :with_role, ->(role) { where("role = #{role}") }
end

class UsersController < ActionController::Base
  def index
    # BAD: user input passed to scope which uses it without sanitization.
    @users = User.with_role(params[:role])
  end
end
