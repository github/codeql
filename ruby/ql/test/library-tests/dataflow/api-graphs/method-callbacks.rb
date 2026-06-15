class BaseClass
    def inheritedInstanceMethod
        yield "taint" # $ sink=Member[Something].Method[foo].Argument[block].ReturnValue.Method[inheritedInstanceMethod].Parameter[block].Argument[0]
    end

    def self.inheritedSingletonMethod
        yield "taint" # $ sink=Member[Something].Method[bar].Argument[block].ReturnValue.Method[inheritedSingletonMethod].Parameter[block].Argument[0]
    end
end

class ClassWithCallbacks < BaseClass
    def instanceMethod
        yield "taint" # $ sink=Member[Something].Method[foo].Argument[block].ReturnValue.Method[instanceMethod].Parameter[block].Argument[0]
    end

    def self.singletonMethod
        yield "bar" # $ sink=Member[Something].Method[bar].Argument[block].ReturnValue.Method[singletonMethod].Parameter[block].Argument[0]
    end

    def escapeSelf
        Something.baz { self }
    end

    def self.escapeSingletonSelf
        Something.baz { self }
    end

    def self.foo x
        x # $ reachableFromSource=Member[BaseClass].Method[foo].Parameter[0]
        x # $ reachableFromSource=Member[ClassWithCallbacks].Method[foo].Parameter[0]
        x # $ reachableFromSource=Member[Subclass].Method[foo].Parameter[0]
    end

    def bar x
        x # $ reachableFromSource=Member[BaseClass].Instance.Method[bar].Parameter[0]
        x # $ reachableFromSource=Member[ClassWithCallbacks].Instance.Method[bar].Parameter[0]
        x # $ reachableFromSource=Member[Subclass].Instance.Method[bar].Parameter[0]
    end
end

class Subclass < ClassWithCallbacks
    def instanceMethodInSubclass
        yield "bar" # $ sink=Member[Something].Method[baz].Argument[block].ReturnValue.Method[instanceMethodInSubclass].Parameter[block].Argument[0]
    end

    def self.singletonMethodInSubclass
        yield "bar" # $ sink=Member[Something].Method[baz].Argument[block].ReturnValue.Method[singletonMethodInSubclass].Parameter[block].Argument[0]
    end
end

Something.foo { ClassWithCallbacks.new }
Something.bar { ClassWithCallbacks }

class ClassWithCallMethod
    def call x
        x # $ reachableFromSource=Method[topLevelMethod].Argument[0].Parameter[0]
        "bar" # $ sink=Method[topLevelMethod].Argument[0].ReturnValue
    end
end

topLevelMethod ClassWithCallMethod.new

blah = topLevelMethod
blah # $ reachableFromSource=Method[topLevelMethod].ReturnValue
