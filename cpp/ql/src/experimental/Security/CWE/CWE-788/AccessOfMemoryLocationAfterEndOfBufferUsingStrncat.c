 
strncat(dest, src, sizeof(dest) - strlen(dest)); //bad:

strncat(dest, src, sizeof(dest) - strlen(dest) -1); //good:
