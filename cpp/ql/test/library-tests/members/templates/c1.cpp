
#include "h.h"

static void f(void) {
    CA::CB<int> x;
    CA::CB<float> y;

    x.operator=(x);
    x.operator=(static_cast<CA::CB<int>&&>(x));
}
