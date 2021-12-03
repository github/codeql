
void duff2_8(int i) {
    int n = (i + 7) / 8;
    switch (i % 8) do {
    case 0: 10;
    case 7: 17;
    case 6: 16;
    case 5: 15;
    case 4: 14;
    case 3: 13;
    case 2: 12;
    case 1: 11;
    } while (--n > 0);
}

void duff2_2(int i) {
    int n = (i + 1) / 2;
    switch (i % 2) do {
    case 0: 10;
    case 1: 11;
    } while (--n > 0);
}

