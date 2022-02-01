...
  fp = fopen("/tmp/name.tmp","w"); // BAD
...
  char filename = tmpnam(NULL);
  fp = fopen(filename,"w"); // BAD
...

  strcat (filename, "/tmp/name.XXXXXX");
  fd = mkstemp(filename);
  if ( fd < 0 ) {
    return error;
  }
  fp = fdopen(fd,"w") // GOOD
...
