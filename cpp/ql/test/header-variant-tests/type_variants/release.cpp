typedef int* IteratorT;

static int g_values[] = {
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9
};

IteratorT first() {
  return g_values;
}

IteratorT last() {
  return g_values + (sizeof(g_values) / sizeof(*g_values));
}

#include "common.h"
