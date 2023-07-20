Something.foo.withCallback do |a, b| #$ source=Member[Something].Method[foo].ReturnValue
    a.something #$ source=Member[Something].Method[foo].ReturnValue.Method[withCallback].Argument[block].Argument[0].Method[something].ReturnValue
    b.somethingElse #$ source=Member[Something].Method[foo].ReturnValue.Method[withCallback].Argument[block].Argument[1].Method[somethingElse].ReturnValue
end #$ source=Member[Something].Method[foo].ReturnValue.Method[withCallback].ReturnValue

Something.withNamedArg do |a:, b: nil| #$ source=Member[Something]
    a.something #$ source=Member[Something].Method[withNamedArg].Argument[block].Parameter[a:].Method[something].ReturnValue
    b.somethingElse #$ source=Member[Something].Method[withNamedArg].Argument[block].Parameter[b:].Method[somethingElse].ReturnValue
end #$ source=Member[Something].Method[withNamedArg].ReturnValue

Something.withLambda ->(a, b) { #$ source=Member[Something]
    a.something #$ source=Member[Something].Method[withLambda].Argument[0].Parameter[0].Method[something].ReturnValue
    b.something #$ source=Member[Something].Method[withLambda].Argument[0].Parameter[1].Method[something].ReturnValue
} #$ source=Member[Something].Method[withLambda].ReturnValue

Something.namedCallback( #$ source=Member[Something]
    onEvent: ->(a, b) {
        a.something #$ source=Member[Something].Method[namedCallback].Argument[onEvent:].Parameter[0].Method[something].ReturnValue
        b.something #$ source=Member[Something].Method[namedCallback].Argument[onEvent:].Parameter[1].Method[something].ReturnValue
    }
) #$ source=Member[Something].Method[namedCallback].ReturnValue

Something.nestedCall1 do |a| #$ source=Member[Something]
    a.nestedCall2 do |b:| #$ reachableFromSource=Member[Something].Method[nestedCall1].Argument[block].Parameter[0]
        b.something #$ source=Member[Something].Method[nestedCall1].Argument[block].Parameter[0].Method[nestedCall2].Argument[block].Parameter[b:].Method[something].ReturnValue
    end #$ source=Member[Something].Method[nestedCall1].Argument[block].Parameter[0].Method[nestedCall2].ReturnValue
end #$ source=Member[Something].Method[nestedCall1].ReturnValue

def getCallback()
    ->(x) {
        x.something #$ source=Member[Something].Method[indirectCallback].Argument[0].Parameter[0].Method[something].ReturnValue
    }
end
Something.indirectCallback(getCallback()) #$ source=Member[Something].Method[indirectCallback].ReturnValue

Something.withMixed do |a, *args, b| #$ source=Member[Something]
    a.something #$ source=Member[Something].Method[withMixed].Argument[block].Parameter[0].Method[something].ReturnValue
    # b.something # not currently handled correctly
end #$ source=Member[Something].Method[withMixed].ReturnValue
