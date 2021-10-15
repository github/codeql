for (var iter in Iterator(aExtraHeaders)) {
    // NOT OK
    var key = iter[0], key = iter[1];
    xhr.setRequestHeader(key, value);
}

// OK
var tmp = f(),
    tmp = tmp + 19;

// OK
var a, b, a = 42;