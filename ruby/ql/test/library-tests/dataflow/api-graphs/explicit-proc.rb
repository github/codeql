Foo.bar proc { |x|
    x # $ reachableFromSource=Member[Foo].Method[bar].Argument[0].Parameter[0]
}

Foo.bar lambda { |x|
    x # $ reachableFromSource=Member[Foo].Method[bar].Argument[0].Parameter[0]
}

Foo.bar Proc.new { |x|
    x # $ reachableFromSource=Member[Foo].Method[bar].Argument[0].Parameter[0]
}
