
constexpr int fun_constexpr();
int fun_not_constexpr();

constexpr int overloaded_fun(int i) {
    return 5;
}

int overloaded_fun(float f) {
    return 6;
}

template <typename T>
constexpr int template_fun(T t) {
    return overloaded_fun(t);
}

void caller(void) {
    int i;
    float f;
    template_fun(i);
    template_fun(f);
}

