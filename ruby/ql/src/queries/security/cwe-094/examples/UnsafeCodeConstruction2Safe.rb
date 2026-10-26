# Uses `define_method` instead of constructing a string
module GoodMakeGetter
  def self.define_getter_class(getter_name, val)
    new_class = Class.new
    new_class.module_eval do
      define_method(getter_name) { val }
    end
    new_class
  end
end

two = GoodMakeGetter.define_getter_class(:two, "bar")
puts "Two is #{two.new.two}"
