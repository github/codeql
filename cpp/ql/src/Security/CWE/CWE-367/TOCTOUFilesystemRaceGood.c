char *file_name;
int fd;
 
/* Initialize file_name */
 
fd = open(
  file_name,
  O_WRONLY | O_CREAT | O_EXCL,
  S_IRWXU
);
if (fd == -1) {
  /* Handle error */
}
 
/* ... */
 
if (fchmod(fd, S_IRUSR) == -1) {
  /* Handle error */
}