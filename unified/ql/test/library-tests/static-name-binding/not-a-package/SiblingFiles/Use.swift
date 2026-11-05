private protocol P {
    let x1: DeclaredTwiceInSameFolder; // unresolved; ambiguous reference
    let x2: OnlyInDef1; // $ access=OnlyInDef1
    let x3: OnlyInDef2; // $ access=OnlyInDef2

    let x4: DeclaredTwiceInSubFolder; // unresolved; ambiguous reference
    let x5: OnlyInSubFolder1; // $ access=OnlyInSubFolder1
    let x6: OnlyInSubFolder2; // $ access=OnlyInSubFolder2
}
