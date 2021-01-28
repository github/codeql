struct buffers
{
    unsigned char buff1[50];
    unsigned char *buff2;
} globalBuff1,*globalBuff2;

unsigned char * globalBuff;
void badFunc0_0(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
}
void nobadFunc0_0(){
	unsigned char buff1[12];
	memset(buff1,12,12);
}
void nobadFunc0_1(){
	unsigned char buff1[12];
	int i;
	memset(buff1,12,12);
	for(i=0;i<12;i++)
		buff1[i]=13;
	free(buff1);
}
void nobadFunc1_0(){
	unsigned char * buff1;
	buff1 = (unsigned char *) malloc(12);
	memset(buff1,12,12);
}
void badFunc1_0(){
	unsigned char * buff1;
	buff1 = (unsigned char *) malloc(12);
	memset(buff1,12,12);
	free(buff1);
}
void badFunc1_1(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;	
	memset(buff1,12,12);
	free(buff1);
}
void nobadFunc2_0_0(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	printf(buff1);
}

void nobadFunc2_0_1(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	printf(buff1+3);
}

void nobadFunc2_0_2(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	printf(*buff1);
}

void nobadFunc2_0_3(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	printf(*(buff1+3));
}
unsigned char * nobadFunc2_0_4(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	return buff1;
}

unsigned char * nobadFunc2_0_5(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	return buff1+3;
}
unsigned char nobadFunc2_0_6(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	return *buff1;
}

unsigned char nobadFunc2_0_7(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	return *(buff1+3);
}
void nobadFunc2_1_0(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	if(*buff1==0)
		printf("123123");
}
void nobadFunc2_1_1(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	if(*(buff1+3)==0)
		printf("123123");
}
void nobadFunc2_1_2(){
	unsigned char buff1[12];
	int i;
	for(i=0;i<12;i++)
		buff1[i]=13;
	memset(buff1,12,12);
	buff1[2]=5;
}
void nobadFunc3_0(unsigned char * buffAll){
	unsigned char * buff1 = buffAll;
	memset(buff1,12,12);
}
void nobadFunc3_1(unsigned char * buffAll){
	unsigned char * buff1 = buffAll+3;
	memset(buff1,12,12);
}
void nobadFunc3_2(struct buffers buffAll){
	unsigned char * buff1 = buffAll.buff1;
	memset(buff1,12,12);
}
void nobadFunc3_3(struct buffers buffAll){
	unsigned char * buff1 = buffAll.buff2;
	memset(buff1,12,12);
}
void nobadFunc3_4(struct buffers buffAll){
	unsigned char * buff1 = buffAll.buff2+3;
	memset(buff1,12,12);
}
void nobadFunc3_5(struct buffers * buffAll){
	unsigned char * buff1 = buffAll->buff1;
	memset(buff1,12,12);
}
void nobadFunc3_6(struct buffers *buffAll){
	unsigned char * buff1 = buffAll->buff2;
	memset(buff1,12,12);
}
void nobadFunc4(){
	unsigned char * buff1 = globalBuff;
	memset(buff1,12,12);
}
void nobadFunc4_0(){
	unsigned char * buff1 = globalBuff;
	memset(buff1,12,12);
}
void nobadFunc4_1(){
	unsigned char * buff1 = globalBuff+3;
	memset(buff1,12,12);
}
void nobadFunc4_2(){
	unsigned char * buff1 = globalBuff1.buff1;
	memset(buff1,12,12);
}
void nobadFunc4_3(){
	unsigned char * buff1 = globalBuff1.buff2;
	memset(buff1,12,12);
}
void nobadFunc4_4(){
	unsigned char * buff1 = globalBuff1.buff2+3;
	memset(buff1,12,12);
}
void nobadFunc4_5(){
	unsigned char * buff1 = globalBuff2->buff1;
	memset(buff1,12,12);
}
void nobadFunc4_6(){
	unsigned char * buff1 = globalBuff2->buff2;
	memset(buff1,12,12);
}

