#include "../../../include/memory.h"
#include "../../../include/utility.h"

using std::move;
using std::shared_ptr;
using std::unique_ptr;

void unique_ptr_arg(unique_ptr<int> up);

void call_unique_ptr_arg(int* p) {
    unique_ptr<int> up(p);
    unique_ptr_arg(move(up));
}

void shared_ptr_arg(shared_ptr<float> sp);

void call_shared_ptr_arg(float* p) {
    shared_ptr<float> sp(p);
    shared_ptr_arg(sp);
}
