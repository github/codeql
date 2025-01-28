#pragma once
#warning "This should happen"
#line  33  "emerald_city.h"  // Magic!
#pragma byte_order(big_endian)
#warning "Not in Kansas any more"

#define MULTILINE \
  /* Hello */ \
  world \
  /* from */ \
  a long \
  /* macro */
#undef \
  MULTILINE

#include \
  "pp.h" \
  \
