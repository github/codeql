
/*
Some padding to make the line numbers >= 10.
At the time of writing, this helps the results
get ordered in a sensible way.
*/

int x;

void f(int cond) {

    switch (cond) {
        case 1:
            x = 111;
            break;
        case 1+2:
            x = 333;
        case 4:
            x = 444;
            break;
        case 5:
        case 6:
            x = 777;
        case 7:
        default:
        case 8:
            x = 888;
        case 9:
            x = 999;
            break;
    }

    return;
}

void g(int cond) {

    switch (cond) {
        case 1:
            x = 111;
            break;
        case 2:
            x = 222;
        /* no default case */
    }
    x = 999;

    return;
}

