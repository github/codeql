typedef unsigned char u8;
typedef unsigned long size_t;
struct UserInput {
    size_t bufferLen;
    u8 buffer[256];
};
struct Baz {
    int foo;
    struct UserInput userInput;
};
struct Bar {
    u8* foo;
    struct Baz * baz;
};
struct Foo {
    struct Bar bar[128];
};
void printf(const char *fmt, ...) {
    return;
}
void * malloc(size_t size) {
    static unsigned char buffer[0x1000];
    static unsigned int offset;
    if (size + offset >= sizeof(buffer)) return nullptr;
    void* m = (void*)&buffer[offset];
    offset += size;
    return m;
}
void * memcpy ( void * destination, const void * source, size_t num ) {
    u8* d = (u8*)destination;
    u8* s = (u8*)source;
    u8* e = d + num;
    while(d != e) {
        *d++ = *s++;
    }
    return destination;
}
void *user_input(void) {
    return (void*)"\x0a\x00\x00\x00\x00\x00\x00\x00The quick brown fox jumps over the lazy dog";
}
void sink(void *o) {
    printf("%p\n", o);
}
#define MAX_BAZ 3
int main(int argc, char** argv) {
    char dst[256];
    struct Foo foo;
    for (int i = 0; i < MAX_BAZ; i++) {
        foo.bar[i].baz = (struct Baz*)malloc(sizeof(struct Baz));
    }
    int i = 0;
    while(i < MAX_BAZ) {
        foo.bar[i].baz->userInput.bufferLen = (size_t)user_input();
        memcpy(foo.bar[i].baz->userInput.buffer, user_input(), sizeof(foo.bar[i].baz->userInput.buffer));
        if(foo.bar[i].baz->userInput.bufferLen > sizeof(foo.bar[i].baz->userInput.buffer))
        {
            printf("The user-supplied input 0x%lx is larger than the buffer 0x%lx!\n", foo.bar[i].baz->userInput.bufferLen, sizeof(foo.bar[i].baz->userInput.buffer));
            return -1;
        }
        memcpy(dst, foo.bar[i].baz->userInput.buffer, foo.bar[i].baz->userInput.bufferLen);
        sink((void*)foo.bar[i].baz->userInput.bufferLen); // $ ast MISSING: ir
        // There is no flow to the following two `sink` calls because the
        // source is the _pointer_ returned by `user_input` rather than the
        // _data_ to which it points.
        sink((void*)foo.bar[i].baz->userInput.buffer); // $ MISSING: ir,ast
        sink((void*)dst); // ir MISSING: ast
        i++;
    }
    return 0;
}
