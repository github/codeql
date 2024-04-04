#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {
    char *userAndFile = argv[2];
    char baseDir[PATH_MAX] = "/home/user/public/";
    char fullPath[PATH_MAX];
    char resolvedPath[PATH_MAX];

    // Attempt to concatenate the base directory and the user-supplied path
    snprintf(fullPath, sizeof(fullPath), "%s%s", baseDir, userAndFile);

    // Resolve the absolute path, normalizing any ".." or "."
    if (realpath(fullPath, resolvedPath) == NULL) {
        perror("Error resolving path");
        return 1;
    }

    // Check if the resolved path starts with the base directory
    if (strncmp(baseDir, resolvedPath, strlen(baseDir)) != 0) {
        return 1;
    }

    // GOOD: Path is within the intended directory
    FILE *file = fopen(resolvedPath, "wb+");
}