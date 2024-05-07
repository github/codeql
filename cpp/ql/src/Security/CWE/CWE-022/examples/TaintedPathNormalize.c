#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {

    char *userAndFile = argv[2];
    // Check for invalid sequences in the user input
    if (strstr(userAndFile, "..") || strchr(userAndFile, '/') || strchr(userAndFile, '\\')) {
        printf("Invalid filename.\n");
        return 1;
    }

    // use `userAndFile` as a safe filename
}