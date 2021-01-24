void workFunction_0(char *s) {
  char buf[80];
  strncat(buf, s, sizeof(buf)-strlen(buf)-1); // GOOD
  strncat(buf, s, sizeof(buf)-strlen(buf));  // BAD
  strncat(buf, "fix", sizeof(buf)-strlen(buf)); // BAD but usually the size of the buffer is calculated manually. 
}
void workFunction_1(char *s) {
#define MAX_SIZE 80
  char buf[MAX_SIZE];
  strncat(buf, s, MAX_SIZE-strlen(buf)-1); // GOOD
  strncat(buf, s, MAX_SIZE-strlen(buf));  // BAD
  strncat(buf, "fix", MAX_SIZE-strlen(buf)); // BAD but usually the size of the buffer is calculated manually. 
}
void workFunction_2_0(char *s) {
  char * buf;
  int len=80;
  buf = (char *) malloc(len);
  strncat(buf, s, len-strlen(buf)-1); // GOOD
  strncat(buf, s, len-strlen(buf));  // BAD
  strncat(buf, "fix", len-strlen(buf)); // BAD but usually the size of the buffer is calculated manually. 
}
void workFunction_2_1(char *s) {
  char * buf;
  int len=80;
  buf = (char *) malloc(len+1);
  strncat(buf, s, len-strlen(buf)-1); // GOOD
  strncat(buf, s, len-strlen(buf));  // GOOD
}
