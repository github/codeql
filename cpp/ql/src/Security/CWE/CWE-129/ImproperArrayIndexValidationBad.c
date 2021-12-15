int example(int socket, int data[]) {
  char inputBuffer[CHAR_ARRAY_SIZE];
  int recvResult;
  int i;

  recvResult = recv(socket, inputBuffer, CHAR_ARRAY_SIZE - 1, 0);
  if (recvResult < 0)
  {
    return -1;
  }

  inputBuffer[recvResult] = '\0';
  i = atoi(inputBuffer);

  // BAD: i has not been validated.
  return data[i];
}
