// Conditional compilation branches hold ordinary member declarations.
class C {
    #if DEBUG
        init(x: Int) {}
        deinit {}
    #endif
}
