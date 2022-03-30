char* path = getenv("PATH");

//...

message = "An internal error has occurred. Please try again or contact a system administrator.\n";
send(socket, message, strlen(message), 0);