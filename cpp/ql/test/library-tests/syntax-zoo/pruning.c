
typedef unsigned char uint8_t;

void f_0(void) {
    if (0) {
        return; // prune
    } else {
        ;
    }
}

void f_1(void) {
    if (1) {
        return;
    } else {
        ; // prune
    }
}

void f_256(void) {
    if (256) {
        return;
    } else {
        ; // prune
    }
}

void f_uint8_t_0(void) {
    if ((uint8_t)0) {
        return; // prune
    } else {
        ;
    }
}

void f_uint8_t_1(void) {
    if ((uint8_t)1) {
        return;
    } else {
        ; // prune
    }
}

void f_uint8_t_256(void) {
    if ((uint8_t)256) {
        return; // prune
    } else {
        ;
    }
}

void f_uint8_t_257(void) {
    if ((uint8_t)257) {
        return;
    } else {
        ; // prune
    }
}

void f_uint8_t_minus1(void) {
    if (255 == (uint8_t)-1) {
        return;
    } else {
        ; // prune
    }
}

void f_v_int_0(void) {
    int i = 0;
    if (i) {
        return; // prune
    } else {
        ;
    }
}

void f_v_int_1(void) {
    int i = 1;
    if (i) {
        return;
    } else {
        ; // prune
    }
}

void f_v_int_256(void) {
    int i = 256;
    if (i) {
        return;
    } else {
        ; // prune
    }
}

void f_v_uint8_t_0(void) {
    uint8_t i = 0;
    if (i) {
        return; // prune
    } else {
        ;
    }
}

void f_v_uint8_t_1(void) {
    uint8_t i = 1;
    if (i) {
        return;
    } else {
        ; // prune
    }
}

void f_v_uint8_t_256(void) {
    uint8_t i = 256;
    if (i) {
        return; // prune
    } else {
        ;
    }
}

void f_v_uint8_t_257(void) {
    uint8_t i = 257;
    if (i) {
        return;
    } else {
        ; // prune
    }
}

void f_v_uint8_t_minus1(void) {
    uint8_t i = -1;
    if (255 == i) {
        return;
    } else {
        ; // prune
    }
}

void switch_f_0(void) {
    switch(255) {
        case 0: break; // prune
    }
}

void switch_f_255(void) {
    switch(255) {
        case 255: break;
    }
}

void switch_f_uint8_t_minus1(void) {
    switch(255) {
        case (uint8_t)-1: break;
    }
}

void switch_f_uint8_t_256(void) {
    switch(256) {
        case (uint8_t)256: break; // prune
    }
}

void switch_f_v_0(void) {
    int i = 255;
    switch(i) {
        case 0: break; // prune
    }
}

void switch_f_v_255(void) {
    int i = 255;
    switch(i) {
        case 255: break;
    }
}

void switch_f_v_uint8_t_minus1(void) {
    int i = 255;
    switch(i) {
        case (uint8_t)-1: break;
    }
}

void switch_f_v_uint8_t_256(void) {
    int i = 256;
    switch(i) {
        case (uint8_t)256: break; // prune
    }
}

void switch_asm(void) {
    int faulted = 0;
    asm volatile ("" : "=r"(faulted) : "0" (faulted));
    switch (faulted) {
        case 1: break;
    }
}