//sz is a signed integer, but malloc expects one that is unsigned.
//Negative values will be interpreted as a large number, which may
//lead to unexpected behavior
char *buf = malloc(sz);
