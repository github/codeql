struct buffers
{
    unsigned char buff1[50];
    unsigned char *buff2;
} globalBuff1,*globalBuff2,globalBuff1_c,*globalBuff2_c;


void badFunc0(){
  unsigned char buff1[12];
  struct buffers buffAll;
  struct buffers * buffAll1;
  
  buff1[strlen(buff1)]=0;
  buffAll.buff1[strlen(buffAll.buff1)]=0;
  buffAll.buff2[strlen(buffAll.buff2)]=0;
  buffAll1->buff1[strlen(buffAll1->buff1)]=0;
  buffAll1->buff2[strlen(buffAll1->buff2)]=0;
  globalBuff1.buff1[strlen(globalBuff1.buff1)]=0;
  globalBuff1.buff2[strlen(globalBuff1.buff2)]=0;
  globalBuff2->buff1[strlen(globalBuff2->buff1)]=0;
  globalBuff2->buff2[strlen(globalBuff2->buff2)]=0;
}
void noBadFunc0(){
  unsigned char buff1[12],buff1_c[12];
  struct buffers buffAll,buffAll_c;
  struct buffers * buffAll1,*buffAll1_c;
  
  buff1[strlen(buff1_c)]=0;
  buffAll.buff1[strlen(buffAll_c.buff1)]=0;
  buffAll.buff2[strlen(buffAll.buff1)]=0;
  buffAll1->buff1[strlen(buffAll1_c->buff1)]=0;
  buffAll1->buff2[strlen(buffAll1->buff1)]=0;
  globalBuff1.buff1[strlen(globalBuff1_c.buff1)]=0;
  globalBuff1.buff2[strlen(globalBuff1.buff1)]=0;
  globalBuff2->buff1[strlen(globalBuff2_c->buff1)]=0;
  globalBuff2->buff2[strlen(globalBuff2->buff1)]=0;
}
void goodFunc0(){
  unsigned char buffer[12];
  int i;
  for(i = 0; i < 6; i++)
    buffer[i] = 'A';
  buffer[i]=0;
}
