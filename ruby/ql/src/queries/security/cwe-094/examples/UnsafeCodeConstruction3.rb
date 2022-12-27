module Invoker
  def attach(klass, name)
    invoker = self
    klass.module_eval <<-CODE
      @@#{name} = invoker

      def #{name}(*args)
        @@#{name}.call(*args)
      end
    CODE
  end
end
