void accept(int arg, char *buf, unsigned long* bufSize);

void testAccept(int socket1, int socket2)
{
  char buffer[1024];
  accept(socket2, 0, 0);
}
