
...
  if (len > 256 || !(ptr = (char *)malloc(len))) // BAD
    return;
    ptr[len-1] = 0;
...
  if (len==0 || len > 256 || !(ptr = (char *)malloc(len))) // GOOD
    return;
    ptr[len-1] = 0;
...
