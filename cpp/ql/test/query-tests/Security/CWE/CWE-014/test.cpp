extern "C" {
	typedef unsigned long long size_t;
	void *memset(void *s, int c, unsigned long n);
	void *__builtin_memset(void *s, int c, unsigned long n);
	typedef int errno_t;
	typedef unsigned int rsize_t;
	errno_t memset_s(void *dest, rsize_t destsz, int ch, rsize_t count);
	char *strcpy(char *dest, const char *src);
	void *memcpy(void *dest, const void *src, unsigned long n);
	void *malloc(unsigned long size);
	void free(void *ptr);
	extern void use_pw(char *pw);
	int printf(const char* format, ...);
	char* gets(char * str);
}

#define PW_SIZE 32

struct mem {
	int a;
	char b[PW_SIZE];
	int c;
};

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
void func(char buff[128], unsigned long long sz) {
	gets(buff);
  memset(buff, 0, PW_SIZE); // GOOD
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
char *func2(char buff[128], unsigned long long sz) {
	gets(buff);
  memset(buff, 0, PW_SIZE); // GOOD
  return buff;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func3(unsigned long long sz) { 
    char buff[128];
		gets(buff);
    memset(buff, 0, PW_SIZE); // BAD
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func4(unsigned long long sz) {
    char buff[128];
		gets(buff);
    memset(buff, 0, PW_SIZE); // BAD [NOT DETECTED]
    strcpy(buff, "Hello");
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func5(unsigned long long sz) {
    char buff[128];
		gets(buff);
    memset(buff, 0, PW_SIZE); // BAD [NOT DETECTED]
    if (sz > 5) {
        strcpy(buff, "Hello");
    }
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func6(unsigned long long sz) {
    struct mem m;
		gets(m.b);
    memset(&m, 0, PW_SIZE); // BAD
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: deleted
void func7(unsigned long long sz) { 
    struct mem m;
		gets(m.b); 
    memset(&m, 0, PW_SIZE); // BAD [NOT DETECTED]
    m.a = 15;
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func8(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
		gets(m->b);
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func9(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
		gets(m->b);
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    free(m);
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func10(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
		gets(m->b);
    memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    m->a = sz;
    m->c = m->a + 1; 
}

// x86-64 gcc 9.2: deleted
// x86-64 clang 9.0.0: deleted
// x64 msvc v19.22: not deleted
void func11(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
		gets(m->b);
    ::memset(m, 0, PW_SIZE); // BAD [NOT DETECTED]
    if (sz > 5) {
    	strcpy(m->b, "Hello");
    }
}

// x86-64 gcc 9.2: not deleted
// x86-64 clang 9.0.0: not deleted
// x64 msvc v19.22: not deleted
int func12(unsigned long long sz) {
    struct mem *m = (struct mem *)malloc(sizeof(struct mem));
		gets(m->b);
    memset(m, 0, sz); // GOOD
    return m->c;
}

int funcN1() {
	char pw[PW_SIZE];
	gets(pw);
	char *pw_ptr = pw;
	memset(pw, 0, PW_SIZE); // GOOD
	use_pw(pw_ptr);
	return 0;
}

char pw_global[PW_SIZE];
int funcN2() {
	gets(pw_global);
	use_pw(pw_global);
	memset(pw_global, 0, PW_SIZE); // GOOD
	return 0;
}

int funcN3(unsigned long long sz) {
    struct mem m;
		gets(m.b);
    memset(&m, 0, sizeof(m)); // GOOD
    return m.a;
}

void funcN(int num) {
	char pw[PW_SIZE];
	int i;
	for (i = 0; i < num; i++)
	{
		gets(pw);
		use_pw(pw);
		memset(pw, 0, PW_SIZE); // GOOD
	}
}

class MyClass
{
public:
	void set(int _x) {
		x = _x;
	}

	int get()
	{
		return x;
	}

	void clear1() {
		memset(&x, 0, sizeof(x)); // GOOD
	}

	void clear2() {
		memset(&(this->x), 0, sizeof(this->x)); // GOOD
	}

private:
	int x;
};

void badFunc0_0(){
	unsigned char buff1[PW_SIZE];
	for(int i = 0; i < PW_SIZE; i++) {
		buff1[i] = 13;
	}
	memset(buff1, 0, PW_SIZE); // BAD
}

void nobadFunc1_0() {
	char* buff1 = (char *) malloc(PW_SIZE);
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // BAD [NOT DETECTED]
}
void badFunc1_0(){
	char * buff1 = (char *) malloc(PW_SIZE);
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // BAD [NOT DETECTED]
	free(buff1);
}
void badFunc1_1(){
	unsigned char buff1[PW_SIZE];
	for(int i = 0; i < PW_SIZE; i++) {
		buff1[i] = 'a' + i;	
	}
	memset(buff1, 0, PW_SIZE); // BAD [NOT DETECTED]
	free(buff1);
}
void nobadFunc2_0_0(){
	unsigned char buff1[PW_SIZE];
	buff1[sizeof(buff1) - 1] = '\0';
	memset(buff1, 0, PW_SIZE); // GOOD
	printf("%s", buff1);
}

void nobadFunc2_0_1(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, '\0', sizeof(buff1));
	memset(buff1, 0, PW_SIZE); // GOOD
	printf("%s", buff1 + 3);
}

void nobadFunc2_0_2(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
	printf("%c", *buff1);
}

void nobadFunc2_0_3(char ch){
	unsigned char buff1[PW_SIZE];
	for(int i = 0; i < PW_SIZE; i++) {
		buff1[i] = ch;
	}
	memset(buff1, 0, PW_SIZE); // GOOD
	printf("%c", *(buff1 + 3));
}

char * nobadFunc2_0_4(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
	return buff1;
}

char * nobadFunc2_0_5(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD

	return buff1+3;
}

unsigned char nobadFunc2_0_6(){
	unsigned char buff1[PW_SIZE];
	buff1[0] = 'z';
	int i;
	memset(buff1, 0, PW_SIZE); // GOOD

	return *buff1;
}

unsigned char nobadFunc2_0_7(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD

	return *(buff1 + 3);
}

bool nobadFunc2_1_0(unsigned char ch){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
	if(*buff1 == ch) { return true; }
	return false;
}

void nobadFunc2_1_2(){
	char buff1[PW_SIZE];
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // BAD [NOT DETECTED]
	buff1[2] = 5;
}

void nobadFunc3_0(char * buffAll){
	char * buff1 = buffAll;
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc3_1(unsigned char * buffAll){
	unsigned char * buff1 = buffAll + 3;
	memset(buff1, 0, PW_SIZE); // GOOD
}

struct buffers
{
    char buff1[50];
    unsigned char *buff2;
};

void nobadFunc3_2(struct buffers buffAll) {
	char * buff1 = buffAll.buff1;
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc3_3(struct buffers buffAll) {
	unsigned char * buff1 = buffAll.buff2;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc3_4(struct buffers buffAll) {
	unsigned char * buff1 = buffAll.buff2 + 3;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc3_5(struct buffers * buffAll) {
	char * buff1 = buffAll->buff1;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc3_6(struct buffers *buffAll){
	unsigned char * buff1 = buffAll->buff2;
	memset(buff1, 0, PW_SIZE); // GOOD
}

char * globalBuff;

void nobadFunc4(){
	char * buff1 = globalBuff;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc4_0(){
	char * buff1 = globalBuff;
	gets(buff1);
	memset(buff1, 0, PW_SIZE); // GOOD
}
void nobadFunc4_1(){
	char * buff1 = globalBuff + 3;
	memset(buff1, 0, PW_SIZE); // GOOD
}

buffers globalBuff1, *globalBuff2;

void nobadFunc4_2(){
	char * buff1 = globalBuff1.buff1;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc4_3(){
	unsigned char * buff1 = globalBuff1.buff2;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc4_4(){
	unsigned char * buff1 = globalBuff1.buff2+3;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc4_5(){
	char * buff1 = globalBuff2->buff1;
	memset(buff1, 0, PW_SIZE); // GOOD
}

void nobadFunc4_6(){
	unsigned char * buff1 = globalBuff2->buff2;
	memset(buff1, 0, PW_SIZE); // GOOD
}

extern void use_byte(unsigned char);

void test_static_func() {
	static unsigned char buffer[PW_SIZE] = {0};
	use_byte(buffer[0]);
	memset(buffer, 42, sizeof(buffer)); // GOOD
}
