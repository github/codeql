char src[256];
char dest1[128];

...

strncpy(dest1, src, sizeof(src)); // wrong: size of dest should be used

char *dest2 = (char *)malloc(sz1 + sz2 + sz3);
strncpy(dest2, src, strlen(src)); // wrong: size of dest should be used
