// semmle-extractor-options: -std=c++14



template<typename T>
constexpr T pi = T(3.141592653589793238462643383);

// Usual specialization rules apply:
template<>
constexpr const char* pi<const char*> = "pi";

int main() {
    auto lambda = [](auto x, auto y) {return x + y;};
    return lambda(1.0, 1.0) + lambda(4, 4) == 10.0;
}
