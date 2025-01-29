#include <windows.h> 
#include <stdio.h>
#include <wincrypt.h>

int main(){
    DWORD ivLen;
    HCRYPTKEY hKey; 

    //BAD
    CryptGetKeyParam(hKey, CRYPT_MODE_ECB, NULL, &ivLen, 0);
}
