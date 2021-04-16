char * strncat(char*, const char*, unsigned);
unsigned strlen(const char*);
void* malloc(unsigned);

void strncat_test1(char *s) {
  char buf[80];
  strncat(buf, s, sizeof(buf) - strlen(buf) - 1); // GOOD
  strncat(buf, s, sizeof(buf) - strlen(buf));  // BAD
  strncat(buf, "fix", sizeof(buf)-strlen(buf)); // BAD [NOT DETECTED]
}

#define MAX_SIZE 80

void strncat_test2(char *s) {
  char buf[MAX_SIZE];
  strncat(buf, s, MAX_SIZE - strlen(buf) - 1); // GOOD
  strncat(buf, s, MAX_SIZE - strlen(buf));  // BAD
  strncat(buf, "fix", MAX_SIZE - strlen(buf)); // BAD [NOT DETECTED]
}

void strncat_test3(char *s) {
  int len = 80;
  char* buf = (char *) malloc(len);
  strncat(buf, s, len - strlen(buf) - 1); // GOOD
  strncat(buf, s, len - strlen(buf));  // BAD
  strncat(buf, "fix", len - strlen(buf)); // BAD [NOT DETECTED]
}

void strncat_test4(char *s) {
  int len = 80;
  char* buf = (char *) malloc(len + 1);
  strncat(buf, s, len - strlen(buf) - 1); // GOOD
  strncat(buf, s, len - strlen(buf)); // GOOD
}

struct buffers
{
    unsigned char array[50];
    unsigned char *pointer;
} globalBuff1,*globalBuff2,globalBuff1_c,*globalBuff2_c;

void strncat_test5(char* s, struct buffers* buffers) {
  unsigned len_array = strlen(buffers->array);
  unsigned max_size = sizeof(buffers->array);
  unsigned free_size = max_size - len_array;
  strncat(buffers->array, s, free_size); // BAD [NOT DETECTED]
}

void strlen_test1(){
  unsigned char buff1[12];
  struct buffers buffAll;
  struct buffers * buffAll1;
  
  buff1[strlen(buff1)]=0; // BAD
  buffAll.array[strlen(buffAll.array)]=0; // BAD
  buffAll.pointer[strlen(buffAll.pointer)]=0; // BAD
  buffAll1->array[strlen(buffAll1->array)]=0; // BAD
  buffAll1->pointer[strlen(buffAll1->pointer)]=0; // BAD
  globalBuff1.array[strlen(globalBuff1.array)]=0; // BAD
  globalBuff1.pointer[strlen(globalBuff1.pointer)]=0; // BAD
  globalBuff2->array[strlen(globalBuff2->array)]=0; // BAD
  globalBuff2->pointer[strlen(globalBuff2->pointer)]=0; // BAD
}

void strlen_test2(){
  unsigned char buff1[12],buff1_c[12];
  struct buffers buffAll,buffAll_c;
  struct buffers * buffAll1,*buffAll1_c;
  
  buff1[strlen(buff1_c)]=0; // GOOD
  buffAll.array[strlen(buffAll_c.array)]=0; // GOOD
  buffAll.pointer[strlen(buffAll.array)]=0; // GOOD
  buffAll1->array[strlen(buffAll1_c->array)]=0; // GOOD
  buffAll1->pointer[strlen(buffAll1->array)]=0; // GOOD
  globalBuff1.array[strlen(globalBuff1_c.array)]=0; // GOOD
  globalBuff1.pointer[strlen(globalBuff1.array)]=0; // GOOD
  globalBuff2->array[strlen(globalBuff2_c->array)]=0; // GOOD
  globalBuff2->pointer[strlen(globalBuff2->array)]=0; // GOOD
}

void strlen_test3(){
  unsigned char buffer[12];
  int i;
  for(i = 0; i < 6; i++)
    buffer[i] = 'A';
  buffer[i]=0;
}
