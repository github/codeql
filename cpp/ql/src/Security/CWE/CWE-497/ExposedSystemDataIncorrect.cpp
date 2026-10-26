char* path = getenv("PATH");

//...

sprintf(buffer, "Cannot find exe on path: %s", path);
send(socket, buffer, strlen(buffer), 0);
