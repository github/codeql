int example(int socket, int data[], int ndata) {
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

  if (i < 0 || ndata <= i) {
    return -1;
  }

  // GOOD: i has been validated.
  return data[i];
}
