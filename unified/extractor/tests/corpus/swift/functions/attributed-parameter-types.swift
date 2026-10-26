func f<D, T>(
    a: inout D,
    b: sending T,
    c: borrowing T,
    d: consuming T,
    e: @escaping (T) -> Void,
    g: @Sendable @escaping () -> D
) {}
