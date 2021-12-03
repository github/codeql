
void print_short(short);
void print_int(int);
void print_long(long);

short array[100];
void loop_over_c_array() {
  for (auto value : array) {
    print_short(value);
  }
}

// A class that can be used with range-based-for, because it has the member
// functions `begin` and `end`.
template<typename T>
struct Vector {
  struct Iterator {
    const T& operator*() const;
    bool operator!=(const Iterator &rhs) const;
    Iterator operator++();
  };
  Iterator begin();
  Iterator end();
};

Vector<int> vector;
void loop_over_vector_object() {
  for (int value : vector) {
    print_int(value);
  }
}

// A class that can be used with range-based-for, because there are `begin` and
// `end` functions that take a `List` as their argument.
template<typename T>
struct List {};

template<typename T>
T* begin(const List<T> &list);
template<typename T>
T* end(const List<T> &list);

void loop_over_list_object(const List<long> &list) {
  for (auto value : list) {
    print_long(value);
  }
}
