int main(int argc, char** argv) {
  char *userName = argv[2];
  
  {
    // BAD: a string from the user is injected directly into
    // a command line.
    char command1[1000] = {0};
    sprintf(command1, "userinfo -v \"%s\"", userName);
    system(command1);
  }

  {
    // GOOD: the user string is encoded by a library routine.
    char userNameQuoted[1000] = {0};
    encodeShellString(userNameQuoted, 1000, userName); 
    char command2[1000] = {0};
    sprintf(command2, "userinfo -v %s", userNameQuoted);
    system(command2);
  }
}
