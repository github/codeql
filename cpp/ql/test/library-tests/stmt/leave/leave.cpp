//semmle-extractor-options: --microsoft
void leave_try_finally_test(bool condition){
    __try {
    if(condition){
       __leave;
      }
    }
    __finally {
    }
}

int except_handler();

void leave_try_except_test(bool condition){
    __try {
        try {
            if(condition)
                __leave;
        }
        catch(...) {
        }
        if(condition){
            __leave;
        }
    }
    __except (except_handler()) {
    }
}
