
void cpp_fun() {
    typeof(({ int twisty(); twisty(); })) twisty();

    decltype( ({using namespace std; using t = int; 1; }) ) i;
}

