// unusedIncludes.cpp

#include "a.h" // $ Alert // unused
#include "b.h"
#include "c.h"
#include "d.hpp"
#include "e.hpp" // $ Alert // unused
#include "f.fwd.hpp" // $ Alert // unused
#include "g" // $ Alert // unused

int val_b = my_func_b();
int *my_c_ptr = &my_var_c;
class_d *my_d_ptr;
