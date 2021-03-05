void workFunction_0(char *s) {
  char buf[80];
  strncat(buf, s, sizeof(buf)-strlen(buf)-1); // GOOD
  strncat(buf, s, sizeof(buf)-strlen(buf));  // BAD
  strncat(buf, "fix", sizeof(buf)-strlen(buf)); // BAD [NOT DETECTED] 
}
void workFunction_1(char *s) {
#define MAX_SIZE 80
  char buf[MAX_SIZE];
  strncat(buf, s, MAX_SIZE-strlen(buf)-1); // GOOD
  strncat(buf, s, MAX_SIZE-strlen(buf));  // BAD
  strncat(buf, "fix", MAX_SIZE-strlen(buf)); // BAD [NOT DETECTED]
}
void workFunction_2_0(char *s) {
  char * buf;
  int len=80;
  buf = (char *) malloc(len);
  strncat(buf, s, len-strlen(buf)-1); // GOOD
  strncat(buf, s, len-strlen(buf));  // BAD
  strncat(buf, "fix", len-strlen(buf)); // BAD [NOT DETECTED]
}
void workFunction_2_1(char *s) {
  char * buf;
  int len=80;
  buf = (char *) malloc(len+1);
  strncat(buf, s, len-strlen(buf)-1); // GOOD
  strncat(buf, s, len-strlen(buf));  // GOOD
}

struct buffers
{
    unsigned char buff1[50];
    unsigned char *buff2;
} globalBuff1,*globalBuff2,globalBuff1_c,*globalBuff2_c;


void badFunc0(){
  unsigned char buff1[12];
  struct buffers buffAll;
  struct buffers * buffAll1;
  
  buff1[strlen(buff1)]=0; // BAD
  buffAll.buff1[strlen(buffAll.buff1)]=0; // BAD
  buffAll.buff2[strlen(buffAll.buff2)]=0; // BAD
  buffAll1->buff1[strlen(buffAll1->buff1)]=0; // BAD
  buffAll1->buff2[strlen(buffAll1->buff2)]=0; // BAD
  globalBuff1.buff1[strlen(globalBuff1.buff1)]=0; // BAD
  globalBuff1.buff2[strlen(globalBuff1.buff2)]=0; // BAD
  globalBuff2->buff1[strlen(globalBuff2->buff1)]=0; // BAD
  globalBuff2->buff2[strlen(globalBuff2->buff2)]=0; // BAD
}
void noBadFunc0(){
  unsigned char buff1[12],buff1_c[12];
  struct buffers buffAll,buffAll_c;
  struct buffers * buffAll1,*buffAll1_c;
  
  buff1[strlen(buff1_c)]=0; // GOOD
  buffAll.buff1[strlen(buffAll_c.buff1)]=0; // GOOD
  buffAll.buff2[strlen(buffAll.buff1)]=0; // GOOD
  buffAll1->buff1[strlen(buffAll1_c->buff1)]=0; // GOOD
  buffAll1->buff2[strlen(buffAll1->buff1)]=0; // GOOD
  globalBuff1.buff1[strlen(globalBuff1_c.buff1)]=0; // GOOD
  globalBuff1.buff2[strlen(globalBuff1.buff1)]=0; // GOOD
  globalBuff2->buff1[strlen(globalBuff2_c->buff1)]=0; // GOOD
  globalBuff2->buff2[strlen(globalBuff2->buff1)]=0; // GOOD
}
void goodFunc0(){
  unsigned char buffer[12];
  int i;
  for(i = 0; i < 6; i++)
    buffer[i] = 'A';
  buffer[i]=0;
}
