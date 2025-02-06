/\[^(.css$)]/; // $ Alert


/(a|^b)c/;


/a*(^b|c)/;

/a\n^b/; // $ Alert


/a\n^b/m;

/a\\n^b/m; // $ Alert - but not recognised

/ab*^c/; // $ Alert


/^^abc/;


/^(^y|^z)(u$|v$)$/;


/x*^y/;


/(?<=(^|\/)(\.|\.\.))$/;
