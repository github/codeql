char * password = malloc(PASSWORD_SIZE);
// ... read and check password
memset_s(password, PASSWORD_SIZE, 0, PASSWORD_SIZE);
free(password);
