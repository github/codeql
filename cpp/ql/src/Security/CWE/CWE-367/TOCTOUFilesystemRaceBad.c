char *file_name;
FILE *f_ptr;
 
/* Initialize file_name */
 
f_ptr = fopen(file_name, "w");
if (f_ptr == NULL)  {
  /* Handle error */
}
 
/* ... */
 
if (chmod(file_name, S_IRUSR) == -1) {
  /* Handle error */
}