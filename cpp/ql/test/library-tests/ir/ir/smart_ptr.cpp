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

void shared_ptr_const_int(shared_ptr<const int>);
void shared_ptr_const_int_ptr(shared_ptr<int* const>);
void shared_ptr_shared_ptr_const_int(shared_ptr<shared_ptr<const int>>);
void shared_ptr_const_shared_ptr_int(shared_ptr<const shared_ptr<int>>);
void shared_ptr_const_shared_ptr_const_int(shared_ptr<const shared_ptr<const int>>);

void call_shared_ptr_consts() {
    shared_ptr<const int> sp_const_int;
    // cannot modify *sp_const_int
    shared_ptr_const_int(sp_const_int);

    shared_ptr<int* const> sp_const_int_pointer;
    // can modify **sp_const_int_pointer
    shared_ptr_const_int_ptr(sp_const_int_pointer);

    shared_ptr<shared_ptr<const int>> sp_sp_const_int;
    // can modify *sp_const_int_pointer
    shared_ptr_shared_ptr_const_int(sp_sp_const_int);

    shared_ptr<const shared_ptr<int>> sp_const_sp_int;
    // can modify **sp_const_int_pointer
    shared_ptr_const_shared_ptr_int(sp_const_sp_int);

    shared_ptr<const shared_ptr<const int>> sp_const_sp_const_int;
    // cannot modify *sp_const_int_pointer or **sp_const_int_pointer
    shared_ptr_const_shared_ptr_const_int(sp_const_sp_const_int);
}