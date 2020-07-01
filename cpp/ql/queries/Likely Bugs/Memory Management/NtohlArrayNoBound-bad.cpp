int get_number_from_network();

int process_network(int[] buff, int buffSize) {
  int i = ntohl(get_number_from_network());
  return buff[i];
}