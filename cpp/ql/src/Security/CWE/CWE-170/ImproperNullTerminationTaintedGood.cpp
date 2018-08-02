char buf[BUF_SIZE];
int count = read(fd, buf, BUF_SIZE);
if (count >= 0) {
  buf[count < BUF_SIZE ? count : BUF_SIZE - 1] = '\0';
  char cpy[BUF_SIZE];
  strcpy(cpy, buf);
}