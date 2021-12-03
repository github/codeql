int main(int argc, char** argv) {
  char *userAndFile = argv[2];
  
  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    strncat(fileName+len, userAndFile, FILENAME_MAX-len-1);
    // BAD: a string from the user is used in a filename
    fopen(fileName, "wb+");
  }

  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    // GOOD: use a fixed file
    char* fixed = "jim/file.txt";
    strncat(fileName+len, fixed, FILENAME_MAX-len-1);
    fopen(fileName, "wb+");
  }
}
