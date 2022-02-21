Object.const_get("Math")
self.class.const_get("Math")
Math.const_get("PI")
Math.const_get(:PI)

module Foo
  class Bar
    VAL = 10

    def const_get(x)
      "my custom const_get method"
    end
  end

  class Baz < Bar
    def self.const_get(x)
        "another custom const_get method"
    end
  end
end

Object.const_get("Foo::Baz::VAL")
Foo.const_get("Bar::VAL")

# Should not be identified as a use of Module#const_get
Foo::Bar.new.const_get 5
Foo::Baz.const_get 5

Foo.class_eval("def foo; 1; end", "file.rb", 1)
Foo.module_eval("def bar; 1; end", "other_file.rb", 2)