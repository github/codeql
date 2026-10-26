...
  chroot("/myFold/myTmp"); // BAD
...
  chdir("/myFold/myTmp"); // BAD
...
  int fd = open("/myFold/myTmp", O_RDONLY | O_DIRECTORY);
  fchdir(fd); // BAD
...
  if (chdir("/myFold/myTmp") == -1) {
    exit(-1);
  }
  if (chroot("/myFold/myTmp") == -1) {  // GOOD
    exit(-1);
  }
...
  if (chdir("/myFold/myTmp") == -1) { // GOOD
    exit(-1);
  }
...
  int fd = open("/myFold/myTmp", O_RDONLY | O_DIRECTORY);
  if(fchdir(fd) == -1) { // GOOD
    exit(-1);
  }
...
