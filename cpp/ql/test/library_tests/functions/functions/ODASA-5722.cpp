template <typename T>
struct NEQ_helper {
};

template <typename T>
struct MyClass : public NEQ_helper<MyClass<T>> {
};
