#include <windows.h> 
#include <stdio.h>
#include <wincrypt.h>

int main(){
    DWORD ivLen;
    HCRYPTKEY hKey; 

    //OKAY
    CryptGetKeyParam(hKey, CRYPT_MODE_CBC, NULL, &ivLen, 0);
}
