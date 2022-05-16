
...
  if (rename(from,to)==0) // BAD
    return;
...
  if (rename(from,to)==0) // GOOD
    return;
  f1 = fopen(from, "r");
  fd = open(to, O_WRONLY|O_CREAT|to_oflags, S_IRUSR|S_IWUSR);
  f2 = fdopen(fd, "w");
...
