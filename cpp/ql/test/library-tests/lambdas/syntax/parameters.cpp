void test_lambda_declarator() {
    [=](int, float) { };

    [](int x = 42) { };

    [](int x) { };

    []() mutable { };

    []() [[nodiscard]] { };
    [] [[nodiscard]] { };

    []() -> void { };

    int i;
    [&i]() {
        i += 1;
    };

    [&i] {
        i += 1;
    };

    [] { };
    [=] () { };
}