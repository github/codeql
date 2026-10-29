typedef struct list {
  list* next;
} list;

void f() {
  int bound = 0;
  int i;
  list* xs;

  while (1) {};                              // Good: Explicit infinite loop.

  for (i = 0; i < 10; i++);                  // Good: Fixed bound.
  while (i < 10) { i += 1; }                 // Good: Fixed bound.
  do { i = i + 1; } while (i <= 10);         // Good: Fixed bound.

  for (i = 0; i > 10; i--);                  // Good: Fixed bound.
  while (i >= 10) { i -= 1; }                // Good: Fixed bound.
  do { i = i - 4; } while (i > 10);          // Good: Fixed bound.

  for (i = 0; i < bound; i++);               // Good: Bound not modified in loop.
  while (i < bound) { i++; }                 // Good: Bound not modified in loop.
  do { i++; } while (i < bound);             // Good: Bound not modified in loop.

  for (i = 0; i < 10; i--);                  // $ Alert // Bad: No increment.
  while (i < 10) {  }                        // $ Alert // Bad: No increment.
  do { i += 2; } while (i > 10);             // $ Alert // Bad: No decrement.
  while (i > 10) { if (i < 5) i--; }         // $ Alert // Bad: Conditional decrement.
  while (i < bound) { i++; bound++; }        // $ Alert // Bad: Bound modified in loop.
  while (i < bound) { i++; bound >>= 1; }    // $ Alert // Bad: Bound modified in loop.
  while (i > bound) { i--; bound += 1; }     // $ Alert // Bad: Bound modified in loop.
  while (i > bound) { i--; bound = bound; }  // $ Alert // Bad: Bound modified in loop.
  for (; xs->next; xs = xs->next);           // $ Alert // Bad: No bound.
  while (i <= -i) {}                         // $ Alert // Bad: Hidden infinite loop.

  while (i < 10) { i = i + 1; }              // Good: Fixed bound.
  while (i > 10) { i = i - 1; }              // Good: Fixed bound.
  while (i < 10) { i = 0; }                  // $ Alert // Bad: increment outside loop
  while (i > 10) { i = 0; }                  // $ Alert // Bad: decrement outside loop
  while (i > 10) { i = 1 - i; }              // $ Alert // Bad: Swapped operands to `-`
}
