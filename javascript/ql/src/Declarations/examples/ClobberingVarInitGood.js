for (var iter in Iterator(aExtraHeaders)) {
    var key = iter[0], value = iter[1];
    xhr.setRequestHeader(key, value);
}
