// lone surrogate halves
'\ud800';
'foo\ud800';
'\ud800bar';
'foo\ud800bar';
/\uD800/;
/foo\ud800/;
/\ud800bar/;
/foo\ud800bar/;
// wrong order
'\udc00\ud800';
// OK
'\uD834\uDF06';
