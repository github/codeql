// OK
for (j = i - 1; j >= 0; --j) {
}

// NOT OK
for (j = i + 1; j < strLength; --j) {
}

// NOT OK
for (var i = 0, l = c.length; i > l; i ++) {
}

// OK
for (i=lower-1; i>=0; --i)
    a[i] = 0;

// NOT OK
for (i=upper+1; i<a.length; --i)
    a[i] = 0;
