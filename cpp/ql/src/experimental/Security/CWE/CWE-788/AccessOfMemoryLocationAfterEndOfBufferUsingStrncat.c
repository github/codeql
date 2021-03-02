 
strncat(dest, source, sizeof(dest) - strlen(dest)); // BAD: writes a zero byte past the `dest` buffer.

strncat(dest, source, sizeof(dest) - strlen(dest) -1); // GOOD: Reserves space for the zero byte.
