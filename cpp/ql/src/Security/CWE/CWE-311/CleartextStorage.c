void writeCredentials() {
  char *password = "cleartext password";
  FILE* file = fopen("credentials.txt", "w");
  
  // BAD: write password to disk in cleartext
  fputs(password, file);
  
  // GOOD: encrypt password first
  char *encrypted = encrypt(password);
  fputs(encrypted, file);
}

