#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {

    char *userAndFile = argv[2];
    // Check for invalid sequences in the user input
    if (strstr(userAndFile, "..") || strchr(userAndFile, '/') || strchr(userAndFile, '\\')) {
        printf("Invalid filename.\n");
        return 1;
    }

    char fileBuffer[FILENAME_MAX] = "/home/user/files/";
    // Ensure buffer overflow is prevented
    strncat(fileBuffer, userAndFile, FILENAME_MAX - strlen(fileBuffer) - 1);
    // GOOD: We know that the filename is safe and stays within the public folder
    FILE *file = fopen(fileBuffer, "wb+");
}