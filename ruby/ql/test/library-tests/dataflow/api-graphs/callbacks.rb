Something.foo.withCallback do |a, b| #$ use=getMember("Something").getMethod("foo").getReturn()
    a.something #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getBlock().getParameter(0).getMethod("something").getReturn()
    b.somethingElse #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getBlock().getParameter(1).getMethod("somethingElse").getReturn()
end #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getReturn()

Something.withNamedArg do |a:, b: nil| #$ use=getMember("Something")
    a.something #$ use=getMember("Something").getMethod("withNamedArg").getBlock().getKeywordParameter("a").getMethod("something").getReturn()
    b.somethingElse #$ use=getMember("Something").getMethod("withNamedArg").getBlock().getKeywordParameter("b").getMethod("somethingElse").getReturn()
end #$ use=getMember("Something").getMethod("withNamedArg").getReturn()

Something.withLambda ->(a, b) { #$ use=getMember("Something")
    a.something #$ use=getMember("Something").getMethod("withLambda").getParameter(0).getParameter(0).getMethod("something").getReturn()
    b.something #$ use=getMember("Something").getMethod("withLambda").getParameter(0).getParameter(1).getMethod("something").getReturn()
} #$ use=getMember("Something").getMethod("withLambda").getReturn()

Something.namedCallback( #$ use=getMember("Something")
    onEvent: ->(a, b) {
        a.something #$ use=getMember("Something").getMethod("namedCallback").getKeywordParameter("onEvent").getParameter(0).getMethod("something").getReturn()
        b.something #$ use=getMember("Something").getMethod("namedCallback").getKeywordParameter("onEvent").getParameter(1).getMethod("something").getReturn()
    }
) #$ use=getMember("Something").getMethod("namedCallback").getReturn()

Something.nestedCall1 do |a| #$ use=getMember("Something")
    a.nestedCall2 do |b:| #$ use=getMember("Something").getMethod("nestedCall1").getBlock().getParameter(0)
        b.something #$ use=getMember("Something").getMethod("nestedCall1").getBlock().getParameter(0).getMethod("nestedCall2").getBlock().getKeywordParameter("b").getMethod("something").getReturn()
    end #$ use=getMember("Something").getMethod("nestedCall1").getBlock().getParameter(0).getMethod("nestedCall2").getReturn()
end #$ use=getMember("Something").getMethod("nestedCall1").getReturn()

def getCallback()
    ->(x) {
        x.something #$ use=getMember("Something").getMethod("indirectCallback").getParameter(0).getParameter(0).getMethod("something").getReturn()
    }
end
Something.indirectCallback(getCallback()) #$ use=getMember("Something").getMethod("indirectCallback").getReturn()

Something.withMixed do |a, *args, b| #$ use=getMember("Something")
    a.something #$ use=getMember("Something").getMethod("withMixed").getBlock().getParameter(0).getMethod("something").getReturn()
    # b.something # not currently handled correctly
end #$ use=getMember("Something").getMethod("withMixed").getReturn()
