int main(int argc, char** argv) {
  char *userAndFile = argv[2];
  
  {
    char fileBuffer[PATH_MAX];
    snprintf(fileBuffer, sizeof(fileBuffer), "/home/%s", userAndFile);
    // BAD: a string from the user is used in a filename
    fopen(fileBuffer, "wb+");
  }
}
