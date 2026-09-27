#define READ_REG(addr) (*(volatile unsigned int *)(addr))
#define MAX_DMA_LEN 64

void *memcpy(void *dest, const void *src, unsigned long n);

void bad_mmio_memcpy(char *dst, char *src) {
  unsigned int len = READ_REG(0x40001000);
  memcpy(dst, src, len);
}
