char src[256];
char dest1[128];

...

strncpy(dest1, src, sizeof(dest1)); // correct

size_t destSize = sz1 + sz2 + sz3;
char *dest2 = (char *)malloc(destSize);
strncpy(dest2, src, destSize); // correct
