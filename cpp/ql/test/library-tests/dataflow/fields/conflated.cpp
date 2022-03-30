int user_input();
void sink(int);

struct A {
  int* p;
  int x;
};

void pointer_without_allocation(const A& ra) {
  *ra.p = user_input();
  sink(*ra.p); // $ ir MISSING: ast
}

void argument_source(void*);
void sink(void*);

void pointer_without_allocation_2() {
  char *raw;
  argument_source(raw);
  sink(raw); // $ ast,ir
}

A* makeA() {
  return new A;
}

void no_InitializeDynamicAllocation_instruction() {
  A* pa = makeA();
  pa->x = user_input();
  sink(pa->x); // $ ast,ir
}

void fresh_or_arg(A* arg, bool unknown) {
  A* pa;
  pa = unknown ? arg : new A;
  pa->x = user_input();
  sink(pa->x); // $ ast,ir
}

struct LinkedList {
  LinkedList* next;
  int y;

  LinkedList() = default;
  LinkedList(LinkedList* next) : next(next) {}
};

// Note: This example also suffers from #113: there is no ChiInstruction that merges the result of the
// InitializeDynamicAllocation instruction into {AllAliasedMemory}. But even when that's fixed there's
// still no dataflow because `ll->next->y = user_input()` writes to {AllAliasedMemory}. 
void too_many_indirections() {
  LinkedList* ll = new LinkedList;
  ll->next = new LinkedList;
  ll->next->y = user_input();
  sink(ll->next->y); // $ ast,ir
}

void too_many_indirections_2(LinkedList* next) {
  LinkedList* ll = new LinkedList(next);
  ll->next->y = user_input();
  sink(ll->next->y); // $ ast,ir
}
