
class __attribute__((lockable)) CSW {
};

CSW* csw;

void f(void) __attribute__((exclusive_locks_required(csw))) {
}

