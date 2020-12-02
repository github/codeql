
template<typename T1> class C;

template<typename T2> long f(C<T2>*);

template<> long f(C<int>* i);

template<typename> long g();

