
void nested1(int i) {
    switch (i) {
        case 1:
            i = 1;
            break;
        {
            ; ; ; ; ; ; ;
            case 2:
                i = 2;
                break;
        }
        default:
            i = 3;
    }
}

void nested2(int i) {
    switch (i) {
        case 1:
            i = 1;
            break;
        {
            ; ; ; ; ; ; ;
            default:
                i = 3;
        }
        case 2:
            i = 2;
            break;
    }
}

