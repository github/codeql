function trimming() {
    sink(source('trimStart').trimStart()); // $ hasTaintFlow=trimStart
    sink(source('trimEnd').trimEnd()); // $ hasTaintFlow=trimEnd
    sink(source('normalize').normalize('NFC')); // $ hasTaintFlow=normalize
    sink(source('trimLeft').trimLeft()); // $ hasTaintFlow=trimLeft
}
