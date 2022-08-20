Something.foo.withCallback do |a, b| #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getReturn()
    a.something #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getBlock().getParameter(0).getMethod("something").getReturn()
    b.somethingElse #$ use=getMember("Something").getMethod("foo").getReturn().getMethod("withCallback").getBlock().getParameter(1).getMethod("somethingElse").getReturn()
end

Something.withNamedArg do |a:, b: nil| #$ use=getMember("Something").getMethod("withNamedArg").getReturn()
    a.something #$ use=getMember("Something").getMethod("withNamedArg").getBlock().getKeywordParameter("a").getMethod("something").getReturn()
    b.somethingElse #$ use=getMember("Something").getMethod("withNamedArg").getBlock().getKeywordParameter("b").getMethod("somethingElse").getReturn()
end

Something.withLambda ->(a, b) {  #$ use=getMember("Something").getMethod("withLambda").getReturn()
    a.something #$ use=getMember("Something").getMethod("withLambda").getParameter(0).getParameter(0).getMethod("something").getReturn()
    b.something #$ use=getMember("Something").getMethod("withLambda").getParameter(0).getParameter(1).getMethod("something").getReturn()
}

Something.namedCallback( #$ use=getMember("Something").getMethod("namedCallback").getReturn()
    onEvent: ->(a, b) {
        a.something #$ use=getMember("Something").getMethod("namedCallback").getKeywordParameter("onEvent").getParameter(0).getMethod("something").getReturn()
        b.something #$ use=getMember("Something").getMethod("namedCallback").getKeywordParameter("onEvent").getParameter(1).getMethod("something").getReturn()
    }
)

Something.nestedCall1 do |a| #$ use=getMember("Something").getMethod("nestedCall1").getReturn()
    a.nestedCall2 do |b:| #$ use=getMember("Something").getMethod("nestedCall1").getBlock().getParameter(0).getMethod("nestedCall2").getReturn()
        b.something #$ use=getMember("Something").getMethod("nestedCall1").getBlock().getParameter(0).getMethod("nestedCall2").getBlock().getKeywordParameter("b").getMethod("something").getReturn()
    end
end

def getCallback()
    ->(x) {
        x.something #$ use=getMember("Something").getMethod("indirectCallback").getParameter(0).getParameter(0).getMethod("something").getReturn()
    }
end
Something.indirectCallback(getCallback()) #$ use=getMember("Something").getMethod("indirectCallback").getReturn()

Something.withMixed do |a, *args, b| #$ use=getMember("Something").getMethod("withMixed").getReturn()
    a.something #$ use=getMember("Something").getMethod("withMixed").getBlock().getParameter(0).getMethod("something").getReturn()
    # b.something # not currently handled correctly
end
