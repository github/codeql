int find(int start, char *str, char goal)
{
    int len = strlen(str);
    //Potential buffer overflow
    for (int i = start; str[i] != 0 && i < len; i++) { 
        if (str[i] == goal)
            return i; 
    }
    return -1;
}

int findRangeCheck(int start, char *str, char goal)
{
    int len = strlen(str);
    //Range check protects against buffer overflow
    for (int i = start; i < len && str[i] != 0 ; i++) {
        if (str[i] == goal)
            return i; 
    }
    return -1;
}



