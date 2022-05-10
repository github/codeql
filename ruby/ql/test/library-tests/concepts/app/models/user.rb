class User < ActiveRecord::Base
  def t1
    # UpdateLikeInstanceMethodCall
    self.update(name: "U15")
    update(name: "U16")
    self.update_attributes({name: "U17", isAdmin: true})

    # UpdateAttributeCall
    self.update_attribute("name", "U18")

    # AssignAttributeCall
    self.name = "U19"
    user.save
  end
end
