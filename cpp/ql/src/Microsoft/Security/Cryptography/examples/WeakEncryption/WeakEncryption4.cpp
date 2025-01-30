#include <windows.h> 
#include <stdio.h>
#include <bcrypt.h>

int main(){
    BCRYPT_ALG_HANDLE hAlg;
    NTSTATUS status; 
    //OKAY
    status = BCryptOpenAlgorithmProvider(&hAlg, BCRYPT_AES_ALGORITHM, MS_PRIMITIVE_PROVIDER, 0);
}


