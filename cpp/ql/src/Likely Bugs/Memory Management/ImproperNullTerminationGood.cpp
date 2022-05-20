char source[100];
memset(source, 'A', 100-1);
source[100-1] = '\0'; // null terminate source

char dest[200];
memset(dest, 'B', 100-1);
dest[100-1] = '\0'; // null terminate destination

strcat(dest, source);