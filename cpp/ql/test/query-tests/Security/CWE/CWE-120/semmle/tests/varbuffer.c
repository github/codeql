// Further test cases for CWE-120.

typedef unsigned long size_t;

typedef struct _MyVarStruct {
    size_t len;
    char buffer[1]; // variable size buffer
} MyVarStruct;

void testMyVarStruct()
{
    MyVarStruct *ptr1 = (MyVarStruct*)malloc(sizeof(MyVarStruct));
    ptr1->len = 0;
    strcpy(ptr1->buffer, ""); // GOOD
    strcpy(ptr1->buffer, "1"); // BAD: length 2, but destination only has length 1
    strcpy(ptr1->buffer, "123456789"); // BAD: length 10, but destination only has length 1
    // ...

    MyVarStruct *ptr2 = (MyVarStruct*)malloc(sizeof(MyVarStruct) + (sizeof(char) * 10));
    ptr2->len = 10;
    strcpy(ptr2->buffer, "123456789"); // GOOD
    strcpy(ptr2->buffer, "1234567890"); // GOOD
    strcpy(ptr2->buffer, "1234567890a"); // BAD: length 12, but destination only has length 11
    strcpy(ptr2->buffer, "1234567890abcdef"); // BAD: length 17, but destination only has length 11
    // ...
}

typedef struct MyFixedStruct1 {
    int len;
    char buffer[2]; // assumed to be a fixed size buffer
} MyFixedStruct1;

void testMyFixedStruct()
{
    MyFixedStruct1 *ptr1 = (MyFixedStruct1 *)malloc(sizeof(MyFixedStruct1));
    ptr1->len = 1;
    strcpy(ptr1->buffer, ""); // GOOD
    strcpy(ptr1->buffer, "1"); // GOOD
    strcpy(ptr1->buffer, "12"); // BAD: length 3, but destination only has length 2
    strcpy(ptr1->buffer, "123456789"); // BAD: length 10, but destination only has length 2
    // ...

    MyFixedStruct1 *ptr2 = (MyFixedStruct1*)malloc(sizeof(MyFixedStruct1) + (sizeof(char) * 10));
    ptr2->len = 11;
    strcpy(ptr2->buffer, "123456789"); // BAD / DUBIOUS: length 10, but destination only has length 2
    strcpy(ptr2->buffer, "1234567890abcdef"); // BAD: length 17, but destination only has length 2
    // ...
}

typedef struct _MyFixedStruct2 {
    char buffer[1]; // fixed size buffer
    size_t len;
} MyFixedStruct2;

void testMyFixedStruct2()
{
    MyFixedStruct2 *ptr1 = (MyFixedStruct2 *)malloc(sizeof(MyFixedStruct2));
    ptr1->len = 1;
    strcpy(ptr1->buffer, ""); // GOOD
    strcpy(ptr1->buffer, "1"); // BAD: length 2, but destination only has length 1
    strcpy(ptr1->buffer, "123456789"); // BAD: length 10, but destination only has length 1
    // ...

    MyFixedStruct2 *ptr2 = (MyFixedStruct2*)malloc(sizeof(MyFixedStruct2) + (sizeof(char) * 10));
    ptr2->len = 11;
    strcpy(ptr2->buffer, "123456789"); // BAD: length 10, but destination only has length 1 [NOT DETECTED]
    strcpy(ptr2->buffer, "1234567890abcdef"); // BAD: length 17, but destination only has length 1
    // ...
}
