char buf[BUF_SIZE];
read(fd, buf, BUF_SIZE);
char cpy[BUF_SIZE];
strcpy(cpy, buf);