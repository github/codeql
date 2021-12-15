
struct stru {
    union {
        int i;
        char s[6];
    } __attribute__((packed));
};

void f(void)
{
    char test1[((int)sizeof(int)) - 5];         // 4 - 5 = -1 error
    char test2[((int)sizeof(int)) - 4];         // 4 - 4 =  0
    char test3[((int)sizeof(int)) - 3];         // 4 - 3 =  1
    char test4[((int)sizeof(struct stru)) - 7]; // 6 - 7 = -1 error
    char test5[((int)sizeof(struct stru)) - 6]; // 6 - 6 =  0
    char test6[((int)sizeof(struct stru)) - 5]; // 6 - 5 =  1
    char test7[9 - ((int)sizeof(struct stru))]; // 9 - 6 =  3
    char test8[8 - ((int)sizeof(struct stru))]; // 8 - 6 =  2
    char test9[7 - ((int)sizeof(struct stru))]; // 7 - 6 =  1
}

