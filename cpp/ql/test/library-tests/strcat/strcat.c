
extern void fiddle_with_string(const char **pstr);

void f(void) {
    const char *str1 = "my string";
    const char *str2 = "my other string";
    const char *str3 = "yet another string";
    char output1[100];
    char output2[100];
    char output3[100];
    char output4[100];

    str2 = "yet another string";
    fiddle_with_string(&str3);

    output1[0] = '\0';
    output2[0] = '\0';
    output3[0] = '\0';
    output4[0] = '\0';
    strcat(output1, str1);
    strcat(output2, str1);
    strcat(output3, str2); // Bad, as str2 gets reassigned
    strcat(output4, str3); // Bad, as str3 gets fiddled with
}

