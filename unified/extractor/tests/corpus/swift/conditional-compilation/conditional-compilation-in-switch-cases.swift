func f(_ x: Int) {
    switch x {
    #if DEBUG
        case 0: break
        case 1: break
    #endif
    default: break
    }
}
