/* Semmle test case for MmioUnsanitizedMemcpy.ql
 * Allowlisted MMIO/DMA register macros flowing into memcpy/memmove/strncpy size parameters.
 */

typedef unsigned int uint32_t;

void *memcpy(void *dest, const void *src, unsigned long n);
void *memmove(void *dest, const void *src, unsigned long n);
char *strncpy(char *dest, const char *src, unsigned long n);

#define READ_REG(addr) (*(volatile uint32_t *)(addr))
#define GET_MMIO(addr) (*(volatile uint32_t *)(addr))
#define REG_READ(addr) (*(volatile uint32_t *)(addr))
#define DMA_READ(addr) (*(volatile uint32_t *)(addr))
#define MAX_DMA_LEN 64

struct VolatileField {
  volatile uint32_t len;
};

volatile uint32_t mmio_len_reg;
struct VolatileField vf;

static void bad_read_reg(char *dst, char *src) {
  uint32_t len = READ_REG(0x40001000); // $ Source
  memcpy(dst, src, len); // $ Alert
}

static void bad_get_mmio(char *dst, char *src) {
  uint32_t len = GET_MMIO(0x50000000); // $ Source
  memmove(dst, src, len); // $ Alert
}

static void bad_reg_read(char *dst, char *src) {
  uint32_t len = REG_READ(0x51000000); // $ Source
  strncpy(dst, src, len); // $ Alert
}

static void bad_dma_read(char *dst, char *src) {
  uint32_t len = DMA_READ(0x60000000); // $ Source
  memcpy(dst, src, len); // $ Alert
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

static void negative_volatile_global(char *dst, char *src) {
  uint32_t len = mmio_len_reg;
  memcpy(dst, src, len); // GOOD
}

static void negative_volatile_field(char *dst, char *src) {
  uint32_t len = vf.len;
  memcpy(dst, src, len); // GOOD
}

static void negative_volatile_deref(char *dst, char *src) {
  volatile uint32_t *reg = (volatile uint32_t *)0x40001000;
  uint32_t len = *reg;
  memcpy(dst, src, len); // GOOD
}

static uint32_t GET_MMIO_fn(unsigned long addr);

static void negative_get_mmio_function(char *dst, char *src) {
  uint32_t len = GET_MMIO_fn(0x50000000);
  memcpy(dst, src, len); // GOOD
}
