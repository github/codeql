module Invoker
  def attach(klass, name, target)
    var = :"@@#{name}"
    klass.class_variable_set(var, target)
    klass.define_method(name) do |*args|
      self.class.class_variable_get(var).send(name, *args)
    end
  end
end
