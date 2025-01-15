#define SIZEOF_CHAR sizeof(char)

char* buffer;
// bug - the code is really going to allocate sizeof(size_t) instead o fthe intended sizeof(char) * 10
buffer = (char*) malloc(sizeof(SIZEOF_CHAR * 10));
