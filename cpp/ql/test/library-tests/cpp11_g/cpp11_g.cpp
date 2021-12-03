template<typename T> T make_val_from_one() {
    T val ({1});
    return val;
}

template<typename T> T make_val_from_three_and_four() {
    T val ({3,4});
    return val;
}

template<typename ...Args> int count_args_1() {
    return sizeof...(Args);
}

template<typename ...Args> int count_args_2(Args... a...) {
    return sizeof...(a);
}

struct int_pair {
  int first;
  int second;
};

struct choose_second {
  choose_second(int first, int second)
    : value(second)
  {
  }
  
  int value;
};

void numbers() {
  int zero  = count_args_1<>();
  int one   = make_val_from_one<int>();
  int two   = count_args_2(1, 1.);
  int three = make_val_from_three_and_four<int_pair>().first;
  int four  = make_val_from_three_and_four<choose_second>().value;
}
