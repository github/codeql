
template<class T>
struct Str {
    static int const val;
};

template<class T>
int const Str<T>::val = 3;

void f(void) {
    int const x = Str<int>::val;
}

// previously compiling this caused an assert in the extractor.
