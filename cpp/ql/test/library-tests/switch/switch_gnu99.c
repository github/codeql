// semmle-extractor-options: -std=gnu99
int f_gnu99(int x) {
    switch(x) {
    case 1:
        return 2;
    case 2:
        break;
    case 3 ... 6:
        break;
    default:
        return 3;
    }
    return 4;
}

