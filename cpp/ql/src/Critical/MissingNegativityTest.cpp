Record records[SIZE] = ...;

int f() {
    int recordIdx = 0;
    recordIdx = readUserInput(); //recordIdx is returned from a function
        // there is no check so it could be negative
    doFoo(&(records[recordIdx])); //but is not checked before use as an array offset
}

