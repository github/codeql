
void f_land(int x, int y) {
    if (x && y) {
        x = 3;
    }
}

void f_lor(int x, int y) {
    if (x || y) {
        x = 3;
    }
}

void f_if_quest2(int x, int y) {
    if (x ?: y) {
        x = 3;
    }
}

void f_if_quest3(int x, int y, int z) {
    if (x ? y : z) {
        x = 3;
    }
}

void f_agg(void) {
    int i[] = {1, 2 + 3, 4 + 5, 6};
}

void f_do_while(int i) {
    do {
        i--;
    } while (i);
}

void f_computed_goto(void) {
    int x;
    void *ptr;
    x = 10;
myLabel:
    x--;
    ptr = &&myLabel;
    x--;
    if (x) {
        goto *ptr;
    }
}

int odasa4753a(void) {
    if (1) {
        return 1;
    }
    return 0;
}

int odasa4753b(void) {
    if (0) {
        return 1;
    }
    return 0;
}

int odasa4762a(int b)
{
  if(1 && b) {
    return 1;
  }
  return 0;
}

int odasa4762b(int b)
{
  if(0 || b) {
    return 1;
  }
  return 0;
}
