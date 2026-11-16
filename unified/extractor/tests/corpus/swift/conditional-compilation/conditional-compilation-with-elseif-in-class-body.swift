class C {
    #if DEBUG
        init(x: Int) {}
    #elseif RELEASE
        init(x: String) {}
    #else
        init() {}
    #endif
}
