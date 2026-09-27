import Target3 // re-exports Target2

private protocol P {
    let x1: A; // $ access=Target2.A
    let x2: B.C; // $ access=Target2.B access=Target2.B.C
    let x3: C; // $ access=Target3.C

    let x4: Target3.A; // $ access=Target2.A
    let x5: Target3.B.C; // $ access=Target2.B access=Target2.B.C
    let x6: Target3.C; // $ access=Target3.C

    // `@_exported import Target2` should not re-export the local 'Target2' name, only its contents
    let x7: Target3.Target2.A; // should not resolve
}
