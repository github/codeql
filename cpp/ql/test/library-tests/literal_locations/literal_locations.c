// Compilable with:
// gcc   -c literal_locations.c 
// clang -c literal_locations.c

typedef struct {
    int i;
    int j;
} intPair;

void f(void) {
    int i = 55555;

    intPair pairs[] = {
        {11111, 22222},
        {33333, 44444}
    };

    int j = 55555;

    switch (i) {
    case 5 ... 8:
        break;
    }

    if (i == -1)
    {
    }
}

