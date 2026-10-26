
#define BUFFER_SIZE (4 * 1024)

void receiveData()
{
  int sock;
  sockaddr_in addr, addr_from;
  char buffer[BUFFER_SIZE];
  int msg_size;
  socklen_t addr_from_len;

  // configure addr
  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(1234);
  addr.sin_addr.s_addr = INADDR_ANY;

  // create and bind the socket
  sock = socket(AF_INET, SOCK_DGRAM, 0);
  bind(sock, (sockaddr *)&addr, sizeof(addr));

  // receive message
  addr_from_len = sizeof(addr_from);
  msg_size = recvfrom(sock, buffer, BUFFER_SIZE, 0, (sockaddr *)&addr_from, &addr_from_len);

  // BAD: the address is controllable by the user, so it
  // could be spoofed to bypass the security check below.
  if ((msg_size > 0) && (strcmp("127.0.0.1", inet_ntoa(addr_from.sin_addr)) == 0))
  {
    // ...
  }
}
