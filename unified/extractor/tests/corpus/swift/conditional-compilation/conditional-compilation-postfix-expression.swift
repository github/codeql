let result = value
    #if DEBUG
        .foo(1)
    #else
        .bar("hi")
    #endif
