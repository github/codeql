private protocol P {
    let x4: DeclaredTwiceInSubFolder; // $ access=Subfolder1.DeclaredTwiceInSubFolder
    let x5: OnlyInSubFolder1; // $ access=OnlyInSubFolder1
    let x6: OnlyInSubFolder2; // $ access=OnlyInSubFolder2
}
