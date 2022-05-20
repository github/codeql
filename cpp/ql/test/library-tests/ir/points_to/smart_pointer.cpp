#include "../../../include/memory.h"
#include "../../../include/utility.h"

using std::shared_ptr;
using std::unique_ptr;

struct S {
    int x;
};

void unique_ptr_init(S s) {
    unique_ptr<S> p(new S); //$ussa=dynamic{1}
    int i = (*p).x; //$ussa=dynamic{1}[0..4)<int>
    *p = s;  //$ussa=dynamic{1}[0..4)<S>
    unique_ptr<S> q = std::move(p);
    *(q.get()) = s;  //$ussa=dynamic{1}[0..4)<S>
    shared_ptr<S> t(std::move(q));
    t->x = 5; //$ussa=dynamic{1}[0..4)<int>
    *t = s; //$ussa=dynamic{1}[0..4)<S>
    *(t.get()) = s; //$ussa=dynamic{1}[0..4)<S>
}

void shared_ptr_init(S s) {
    shared_ptr<S> p(new S); //$ussa=dynamic{1}
    int i = (*p).x; //$ussa=dynamic{1}[0..4)<int>
    *p = s;  //$ussa=dynamic{1}[0..4)<S>
    shared_ptr<S> q = std::move(p);
    *(q.get()) = s;  //$ussa=dynamic{1}[0..4)<S>
    shared_ptr<S> t(q);
    t->x = 5; //$ussa=dynamic{1}[0..4)<int>
    *t = s; //$ussa=dynamic{1}[0..4)<S>
    *(t.get()) = s; //$ussa=dynamic{1}[0..4)<S>
}
