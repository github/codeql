
for (j = i - 1; j >= 0; --j) {
}

for (j = i + 1; j < strLength; --j) { // $ TODO-MISSING: Alert
} // $ TODO-SPURIOUS: Alert

for (var i = 0, l = c.length; i > l; i ++) { // $ TODO-MISSING: Alert
} // $ TODO-SPURIOUS: Alert


for (i=lower-1; i>=0; --i)
    a[i] = 0;

for (i=upper+1; i<a.length; --i) // $ TODO-MISSING: Alert
    a[i] = 0; // $ TODO-SPURIOUS: Alert
