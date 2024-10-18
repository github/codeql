for(int i = 0; i < 10; i++) {
  char* free = malloc(0x100);
  char* notfree = malloc(0x100);
  if(i == 5) {
    free(free);
    break;
    }
  free(free);
  free(notfree);
}
