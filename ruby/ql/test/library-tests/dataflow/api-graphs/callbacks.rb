Something.foo.withCallback do |a, b| # $ source=Member[Something].Method[foo].ReturnValue source=Member[Something].Method[foo].ReturnValue.Method[withCallback].ReturnValue
    a.something # $ source=Member[Something].Method[foo].ReturnValue.Method[withCallback].Argument[block].Argument[0].Method[something].ReturnValue
    b.somethingElse # $ source=Member[Something].Method[foo].ReturnValue.Method[withCallback].Argument[block].Argument[1].Method[somethingElse].ReturnValue
end

Something.withNamedArg do |a:, b: nil| # $ source=Member[Something] source=Member[Something].Method[withNamedArg].ReturnValue
    a.something # $ source=Member[Something].Method[withNamedArg].Argument[block].Parameter[a:].Method[something].ReturnValue
    b.somethingElse # $ source=Member[Something].Method[withNamedArg].Argument[block].Parameter[b:].Method[somethingElse].ReturnValue
end

Something.withLambda ->(a, b) { # $ source=Member[Something] source=Member[Something].Method[withLambda].ReturnValue
    a.something # $ source=Member[Something].Method[withLambda].Argument[0].Parameter[0].Method[something].ReturnValue
    b.something # $ source=Member[Something].Method[withLambda].Argument[0].Parameter[1].Method[something].ReturnValue
}

Something.namedCallback( # $ source=Member[Something] source=Member[Something].Method[namedCallback].ReturnValue
    onEvent: ->(a, b) {
        a.something # $ source=Member[Something].Method[namedCallback].Argument[onEvent:].Parameter[0].Method[something].ReturnValue
        b.something # $ source=Member[Something].Method[namedCallback].Argument[onEvent:].Parameter[1].Method[something].ReturnValue
    }
)

Something.nestedCall1 do |a| # $ source=Member[Something] source=Member[Something].Method[nestedCall1].ReturnValue
    a.nestedCall2 do |b:| # $ reachableFromSource=Member[Something].Method[nestedCall1].Argument[block].Parameter[0] source=Member[Something].Method[nestedCall1].Argument[block].Parameter[0].Method[nestedCall2].ReturnValue
        b.something # $ source=Member[Something].Method[nestedCall1].Argument[block].Parameter[0].Method[nestedCall2].Argument[block].Parameter[b:].Method[something].ReturnValue
    end
end

def getCallback()
    ->(x) {
        x.something # $ source=Member[Something].Method[indirectCallback].Argument[0].Parameter[0].Method[something].ReturnValue
    }
end
Something.indirectCallback(getCallback()) # $ source=Member[Something].Method[indirectCallback].ReturnValue
Something.withMixed do |a, *args, b| # $ source=Member[Something] source=Member[Something].Method[withMixed].ReturnValue
    a.something # $ source=Member[Something].Method[withMixed].Argument[block].Parameter[0].Method[something].ReturnValue
    # b.something # not currently handled correctly
end
