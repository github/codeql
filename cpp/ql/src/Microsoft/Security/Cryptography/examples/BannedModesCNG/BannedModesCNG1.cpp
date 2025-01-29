#include <windows.h> 
#include <stdio.h>
#include <bcrypt.h>

int main(){
    BCRYPT_ALG_HANDLE aes;

    //BAD
    status = BCryptSetProperty(aes, 
                BCRYPT_CHAINING_MODE, 
                (PBYTE)BCRYPT_CHAIN_MODE_ECB,
                sizeof(BCRYPT_CHAIN_MODE_ECB),
                0);
}
