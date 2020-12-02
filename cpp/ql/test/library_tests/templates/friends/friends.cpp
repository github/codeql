
template<typename TTT> class C;

template<typename TTT> long f(C<TTT>*);

template<typename TTT>
  class C {
  public:
    friend long f<>(C<TTT>*);
  };

template<> long f(C<char>* i);
template<> long f(C<int>* i);

extern template class C<char>;
extern template long f(C<char>*);

extern template class C<int>;
extern template long f(C<int>*);

