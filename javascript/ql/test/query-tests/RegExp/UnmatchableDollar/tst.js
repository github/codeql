/\[^(.css$)]/; // $ Alert


/a(b$|c)/;


/(a|b$)c*/;

/a$\nb/; // $ Alert


/a$\nb/m;

/a$\\nb/m; // $ MISSING: Alert

/a$b*c/; // $ Alert


/^(^y|^z)(u$|v$)$/;


/.*x$$$/;


/x$y*/;


/x(?!y+$).*y.*/;


/x(?=[yz]+$).*yz.*/;

/(?<=$x)yz/; // $ Alert
