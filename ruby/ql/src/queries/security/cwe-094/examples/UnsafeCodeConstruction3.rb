module Invoker
  def attach(klass, name, target)
    klass.module_eval <<-CODE
      @@#{name} = target

      def #{name}(*args)
        @@#{name}.#{name}(*args)
      end
    CODE
  end
end
