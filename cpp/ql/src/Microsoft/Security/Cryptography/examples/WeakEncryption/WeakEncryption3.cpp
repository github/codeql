#include <windows.h> 
#include <stdio.h>
#include <bcrypt.h>

int main(){
    BCRYPT_ALG_HANDLE hAlg;
    NTSTATUS status; 
    //BAD
    status = BCryptOpenAlgorithmProvider(&hAlg, BCRYPT_DES_ALGORITHM, MS_PRIMITIVE_PROVIDER, 0);
}


