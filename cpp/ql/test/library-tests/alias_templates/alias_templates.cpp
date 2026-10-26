template <typename T, typename U> struct pair {
  T first;
  U second;
};

struct coords {
  int x;
  template <typename T> using a_wild_alias_template_appeared = pair<T, int>;
  int y;
  int z;
  enum {
    after_alias_template = 1
  };
};

enum {
  global_constant = 0
};
