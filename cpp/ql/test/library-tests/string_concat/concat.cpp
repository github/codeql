// #include <iostream>
// #include <string>
// #include <stdio.h>
// #include <string.h>
// #include <sstream>
#include "stl.h"

int sprintf(char *s, const char *format, ...);
char *strcat(char * s1, const char * s2);

using namespace std;


void test1(){
    string str1 = "Hello";
    string str2 = "World";
    string str3 = "!";
    string str4 = "Concatenation";
    string str5 = "is";
    string str6 = "fun";

    // Using the + operator
    string result1 = str1 + " " + str2 + str3;

    // Using the append() function
    //----TODO: currently not modeled----
    // string result2 = str4.append(" ") + str5.append(" ") + str6;

    // Using the insert() function
    //----TODO: currently not modeled----
    // string result3 = str1.insert(5, " ") + str2.insert(5, "! ");

    // Using the replace() function
    //----TODO: currently not modeled----
    // string result4 = str1.replace(0, 5, "Hi") + str2.replace(0, 5, "There");

    // Using the push_back() function
    //----TODO: currently not modeled----
    // string result5;
    // for (char c : str1) {
    //     result5.push_back(c);
    // }

    // Using the stream operator
    string result6;
    std::stringstream ss;
    ss << str1 << " " << str2 << str3;
}


void test2(char* ucstr) {
    char str1[20] = "Hello";
    char str2[20] = "World";
    char result[40];
    char *result2;

    // Using sprintf
    sprintf(result, "%s %s %s", str1, str2, ucstr);

    // Using strcat
    strcat(str1, ucstr);
}
