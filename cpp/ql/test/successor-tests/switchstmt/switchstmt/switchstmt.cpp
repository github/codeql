// semmle-extractor-options: -std=c++17

void g(int x) {
     switch (
         int y = x;
         y) {
        case 1:
        case 2:
        default:
    }
    ;
}
