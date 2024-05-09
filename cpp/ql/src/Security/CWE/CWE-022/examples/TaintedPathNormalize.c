#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {
    char *fileName = argv[2];
    // Check for invalid sequences in the user input
    if (strstr(fileName , "..") || strchr(fileName , '/') || strchr(fileName , '\\')) {
        printf("Invalid filename.\n");
        return 1;
    }

    char fileBuffer[PATH_MAX];
    snprintf(fileBuffer, sizeof(fileBuffer), "/home/user/files/%s", fileName);
    // GOOD: We know that the filename is safe and stays within the public folder
    FILE *file = fopen(fileBuffer, "wb+");
}