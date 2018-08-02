__declspec(align(32)) struct mystruct { short myshort; };

int main(void) {
    return 0ui32;
}

void ms_asm (void)
    __asm ("foo");

void gnu_asm() {
    __asm nop
}



// Test for CPP-184
_Pragma("clang diagnostic push")
_Pragma("clang diagnostic pop")
