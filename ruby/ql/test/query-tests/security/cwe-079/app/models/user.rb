class User < ActiveRecord::Base
  def is_dummy_user?
    self.user_id == 0
  end

  def raw_name
    me = self
    me.handle
  end

  def display_name
    self.real_name || self.handle
  end
end
