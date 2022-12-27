module Invoker
  def attach(klass, name)
    var = :"@@#{name}"
    klass.class_variable_set(var, self)
    klass.define_method(name) do |*args|
      self.class.class_variable_get(var).call(*args)
    end
  end
end
