
class C;
class D;

template <class T> class E {
    template<class U> friend class E;
    template<class U> friend class F;
};

template <class T> class F : public E<T> {
    template<class U> friend class E;
};

void f(void) {
    E<C> ec;
    F<D> fd;
}

