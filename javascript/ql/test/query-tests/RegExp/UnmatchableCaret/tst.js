/\[^(.css$)]/; // $ Alert


/(a|^b)c/;


/a*(^b|c)/;

/a\n^b/; // $ Alert


/a\n^b/m;

/a\\n^b/m; // $ MISSING: Alert

/ab*^c/; // $ Alert


/^^abc/;


/^(^y|^z)(u$|v$)$/;


/x*^y/;


/(?<=(^|\/)(\.|\.\.))$/;
