/* Semmle test case for MmioUnsanitizedMemcpy.ql
 * MMIO/DMA register reads flowing into memcpy/memmove/strncpy size parameters.
 */

typedef unsigned int uint32_t;

void *memcpy(void *dest, const void *src, unsigned long n);
void *memmove(void *dest, const void *src, unsigned long n);
char *strncpy(char *dest, const char *src, unsigned long n);

#define READ_REG(addr) (*(volatile uint32_t *)(addr))
#define MAX_DMA_LEN 64

uint32_t GET_MMIO(unsigned long addr);
uint32_t DMA_READ(unsigned long addr);

volatile uint32_t mmio_len_reg;

static void bad_read_reg(char *dst, char *src) {
  uint32_t len = READ_REG(0x40001000); // $ Source
  memcpy(dst, src, len); // $ Alert
}

static void bad_get_mmio(char *dst, char *src) {
  uint32_t len = GET_MMIO(0x50000000); // $ Source
  memmove(dst, src, len); // $ Alert
}

static void bad_volatile_global(char *dst, char *src) {
  uint32_t len = mmio_len_reg; // $ Source
  strncpy(dst, src, len); // $ Alert
}

static void good_bounded(char *dst, char *src) {
  uint32_t len = READ_REG(0x40001000);
  if (len <= MAX_DMA_LEN)
    memcpy(dst, src, len); // GOOD
}

static void good_early_return(char *dst, char *src) {
  uint32_t len = DMA_READ(0x60000000);
  if (len > MAX_DMA_LEN)
    return;
  memcpy(dst, src, len); // GOOD
}

static void good_constant_size(char *dst, char *src) {
  uint32_t len = READ_REG(0x40001000);
  memcpy(dst, src, 32); // GOOD — constant size, not tainted sink
}
