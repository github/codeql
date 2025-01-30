#include <windows.h> 
#include <stdio.h>
#include <wincrypt.h>

int main(){
    HCRYPTPROV hCryptProv;
    HCRYPTKEY hKey; 

    //OKAY
    if(CryptGenKey( hCryptProv, CALG_AES_128, KEYLENGTH | CRYPT_EXPORTABLE, &hKey))
    {
        printf("A session key has been created.\n");
    }
}
