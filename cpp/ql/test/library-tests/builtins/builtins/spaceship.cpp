// semmle-extractor-options: --clang --clang_version 240000 -std=c++23

namespace std {
  struct strong_ordering {
    int n;
    constexpr operator int() const { return n; }
    static const strong_ordering less, equal, greater;
  };
  constexpr strong_ordering strong_ordering::less = {-1};
  constexpr strong_ordering strong_ordering::equal = {0};
  constexpr strong_ordering strong_ordering::greater = {1};
}

struct S {
  int i;

  friend auto operator<=>(S lhs, int rhs) {
    return rhs <=> lhs.i;
  }
};

bool b_lt_synthesizes_from_spaceship1 = __builtin_lt_synthesizes_from_spaceship(const S&, const int&);
bool b_lt_synthesizes_from_spaceship2 = __builtin_lt_synthesizes_from_spaceship(int, int);
bool b_gt_synthesizes_from_spaceship1 = __builtin_gt_synthesizes_from_spaceship(const S&, const int&);
bool b_gt_synthesizes_from_spaceship2 = __builtin_gt_synthesizes_from_spaceship(int, int);
bool b_le_synthesizes_from_spaceship1 = __builtin_le_synthesizes_from_spaceship(const S&, const int&);
bool b_le_synthesizes_from_spaceship2 = __builtin_le_synthesizes_from_spaceship(int, int);
bool b_ge_synthesizes_from_spaceship1 = __builtin_ge_synthesizes_from_spaceship(const S&, const int&);
bool b_ge_synthesizes_from_spaceship2 = __builtin_ge_synthesizes_from_spaceship(int, int);
