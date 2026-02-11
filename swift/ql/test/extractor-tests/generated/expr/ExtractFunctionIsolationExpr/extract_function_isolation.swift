func foo(x: @isolated(any) () -> ()) {
    let isolation = x.isolation
}
