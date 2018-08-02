// semmle-extractor-options: --microsoft
void ms_try_except(int j) {
    int x;

    __try {
        x = 1;
    }
    __except (j) {
        x = 2;
    }

    __try {
        x = 3;
    }
    __finally {
        x = 4;
    }
}

