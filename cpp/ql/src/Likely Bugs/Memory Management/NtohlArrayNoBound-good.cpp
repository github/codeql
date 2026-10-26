uint32_t get_number_from_network();

int process_network(int[] buff, uint32_t buffSize) {
  uint32_t i = ntohl(get_number_from_network());
  if (i < buffSize) {
    return buff[i];
  } else {
    return -1;
  }
}