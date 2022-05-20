
#define OPEN {
void igFun() {
    OPEN
    }
    int ii = 0;
    // EDG used to not give the initialization for this ii capture an
    // end location:
    auto fp = [&ii](void) {
        return 1;
    };
}

