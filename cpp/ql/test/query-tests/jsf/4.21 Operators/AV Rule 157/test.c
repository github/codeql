
int z;

int pureFun(void) {
    return 3;
}

int imPureFun(void) {
    z++;
    return 4;
}

int strcmp(char *x, char *y);
int unknownFun(char *x, char *y);

void f(int x, int y) {
    if (x && y)
        x++;

    if (x && y++)
        x++;

    if (x && pureFun())
        x++;

    if (x && imPureFun())
        x++;

    if (x && strcmp("foo", "bar"))
        x++;

    if (x && unknownFun("foo", "bar"))
        x++;
}

