function flatMapThisArg() {
    [0].flatMap(function (x, i) {
        sink(this); // $ hasValueFlow=flatMap.thisArg
        sink(i); // OK - the index, not thisArg
        return [];
    }, source('flatMap.thisArg'));
}
