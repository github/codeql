strncat(dest, src, strlen(dest)); //wrong: should use remaining size of dest

strncat(dest, src, sizeof(dest)); //wrong: should use remaining size of dest. 
                                  //Also fails if dest is a pointer and not an array.
 
strncat(dest, source, sizeof(dest) - strlen(dest)); // wrong: writes a zero byte past the `dest` buffer.

strncat(dest, source, sizeof(dest) - strlen(dest) - 1); // correct: reserves space for the zero byte.
