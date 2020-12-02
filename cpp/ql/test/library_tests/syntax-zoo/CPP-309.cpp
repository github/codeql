typedef unsigned long size_t;

void * operator new[](size_t count, int arg1, int arg2);

template<typename T>
void callNew(T arg) {
    new(2, 3) int[5];
}

void callCallNew() {
    callNew(1);
}
