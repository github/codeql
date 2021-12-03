#define va_list void*
#define va_start(x, y) x = NULL;
#define va_arg(x, y) ((y)x)
#define va_end(x)
#define NULL 0

char* strcat(char* destination, const char* source);
char* strcpy(char* destination, const char* source);
int strlen(const char* str);
char* strcpy(char* destination, const char* source);
char* strstr(char* s1, const char* s2);
const char* strchr(const char* s, int c);
int strcmp(const char *s1, const char *s2);

char* global = "         ";

void addNull(char* buffer) {
  buffer[0] = '\0';
}

void addNullVarargs(int val, ...) {
  char* ptr;
  va_list args;
  va_start(args, val);
  while ((ptr = va_arg(args, int*)) != NULL) {
    *ptr = '\0';
  }
}

void addNullAsm(char* buffer) {
  int src = 0;
  asm ("mov %1, %0\n\t"
       "add $1, %0"
       : "=r" (buffer)
       : "r" (src));
}

void addNullWrapper(char* buffer) {
  addNullAsm(buffer);
}

void addNullFunctionPointer(char* buffer) {
  int (*ptr)(char*) = addNullWrapper;
  ptr(buffer);
}

void mayAdd() {
	char* data = malloc(10*sizeof(char));
	
	// Assignment (dereferencing)
	*data = 0;
	*data++ = '\0';
	
	// Assignment (array access)
	data[9] = 0;
	
	// Assignment to another stack variable
	char* data2 = data;
	data2[9] = 0;
	
	// Assignment to global variable
	global = data;
	global = data + 1;
	
	// Function call
	strcpy(data, "string");
	addNull(data);
	addNullVarargs(0, data);
	addNullAsm(data);
	addNullWrapper(data);
	addNullFunctionPointer(data);
}

void dummy(char* data) { }

void notMayAdd() {
	char* data = malloc(10*sizeof(char));
	
	// Assignment (dereferencing)
	*data = 2;
	*data++ = 1;
	
	// Assignment (array access)
	data[0] = 1;
	data[9] = 'a';
	
	// Assignment to another stack variable
	char* data2 = malloc(10*sizeof(char));
	data2[0] = 0;
	data2 = data;
	
	// Function call
	dummy(data);
}

int strlenWrapper(char* data) {
	return strlen(data);
}

void mustBe(char* data) {
	char* buffer;
	strlen(data);
	strcpy(buffer, data);
	strcmp(buffer, data);
	strchr(data, 0);
	strstr(data, buffer);
	strlenWrapper(data);
}

int strlenWrapperSafe(char* data, int max) {
	data[max - 1] = '\0';
	return strlen(data);
}

void notMustBe(char* data) {
	char buffer[10] = "";
	strlenWrapperSafe(data, 10);
	strcpy(data, "string");
}