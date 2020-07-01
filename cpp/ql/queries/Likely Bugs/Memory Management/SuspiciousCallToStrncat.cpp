strncat(dest, src, strlen(dest)); //wrong: should use remaining size of dest

strncat(dest, src, sizeof(dest)); //wrong: should use remaining size of dest. 
                                  //Also fails if dest is a pointer and not an array.
