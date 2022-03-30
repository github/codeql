// NOT OK
/\[^(.css$)]/;

// OK
/a(b$|c)/;

// OK
/(a|b$)c*/;

// NOT OK
/a$\nb/;

// OK
/a$\nb/m;

// NOT OK, but not recognised
/a$\\nb/m;

// NOT OK
/a$b*c/;

// OK
/^(^y|^z)(u$|v$)$/;

// OK
/.*x$$$/;

// OK
/x$y*/;

// OK
/x(?!y+$).*y.*/;

// OK
/x(?=[yz]+$).*yz.*/;

// NOT OK
/(?<=$x)yz/;
