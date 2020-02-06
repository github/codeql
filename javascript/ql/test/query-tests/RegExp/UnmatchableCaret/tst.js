// NOT OK
/\[^(.css$)]/;

// OK
/(a|^b)c/;

// OK
/a*(^b|c)/;

// NOT OK
/a\n^b/;

// OK
/a\n^b/m;

// NOT OK, but not recognised
/a\\n^b/m;

// NOT OK
/ab*^c/;

// OK
/^^abc/;

// OK
/^(^y|^z)(u$|v$)$/;

// OK
/x*^y/;

// OK
/(?<=(^|\/)(\.|\.\.))$/;
