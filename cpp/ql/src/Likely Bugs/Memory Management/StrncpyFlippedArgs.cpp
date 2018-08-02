strncpy(dest, src, sizeof(src)); //wrong: size of dest should be used
strncpy(dest, src, strlen(src)); //wrong: size of dest should be used
