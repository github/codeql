struct HasDestructor {
    ~HasDestructor();
};

template<typename T>
void callDestructor(T *x) {
    x->~T();
}

template void callDestructor<int>(int *x);
template void callDestructor<HasDestructor>(HasDestructor *x);
