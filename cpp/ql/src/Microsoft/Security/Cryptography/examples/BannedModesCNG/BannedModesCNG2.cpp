#include <windows.h> 
#include <stdio.h>
#include <bcrypt.h>

int main(){
    BCRYPT_ALG_HANDLE aes;

    //OKAY
    status = BCryptSetProperty(aes, 
                BCRYPT_CHAINING_MODE, 
                (PBYTE)BCRYPT_CHAIN_MODE_CBC,
                sizeof(BCRYPT_CHAIN_MODE_CBC),
                0);
}
