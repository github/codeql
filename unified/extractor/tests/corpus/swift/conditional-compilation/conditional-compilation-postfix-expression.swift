let result = value
    #if DEBUG
        .foo(1)
    #else
        .bar("hi")
    #endif

let branches = makeValue()
    #if FIRST
        .foo(.argument).bar[0]!
    #elseif SECOND
        .otherMember
    #else
        .baz()
    #endif

let noElse = makeValue()
    #if FIRST
        .foo()
    #elseif SECOND
        .bar()
    #endif

let emptyBranch = value
    #if FIRST
        .foo()
    #else
    #endif

let nested = value
    #if FIRST
        .foo()
            #if SECOND
                .bar()
            #else
                .baz()
            #endif
    #else
        .otherMember
    #endif

let inChain = value.foo()
    #if CHAIN
        .bar()
    #endif

let nestedWithoutBase = value
    #if FIRST
        #if SECOND
            .foo()
        #else
            .bar()
        #endif
    #else
        .baz()
    #endif

let postfixChain = baseExpr
    #if CONDITION_1
        #if CONDITION_2
            .someMethod()
        #endif
        #if CONDITION_3
            .otherMethod()
        #endif
    #endif
