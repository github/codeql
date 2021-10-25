...
  FILE *fp = fopen(filename,"w"); // BAD
...
  umask(S_IXUSR|S_IRWXG|S_IRWXO);
  FILE *fp;
  fp = fopen(filename,"w"); // GOOD
  chmod(filename,S_IRUSR|S_IWUSR);
  fprintf(fp,"%s\n","data to file");
  fclose(fp);
...
