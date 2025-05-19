
#include "./bcrypt.h"
using namespace std;

char* getString();

char* password = getString();
char* salt = getString();

int strlen(char *s);

void test_bad1()
{
    NTSTATUS Status;
    BYTE DerivedKey[64];

    BCRYPT_ALG_HANDLE handle;
    // BAD hash algorithm handle generated here
    Status = BCryptOpenAlgorithmProvider(&handle, BCRYPT_MD5_ALGORITHM, NULL, 0);

    if (Status != 0)
    {
        //std::cout << "BCryptOpenAlgorithmProvider exited with error message " << Status;
        goto END;
    }

    // BAD Hash algorithm handle
    // BAD salt length
    // BAD iteration count
    // BAD Key length
    Status = BCryptDeriveKeyPBKDF2(handle, (PUCHAR)password, strlen(password), (PUCHAR)salt, 8, 2048, (PUCHAR)DerivedKey, 8, 0);
    //Status = BCryptDeriveKeyPBKDF2(handle, (PUCHAR)password.data(), password.length(), (PUCHAR)salt.data(), 8, 2048, (PUCHAR)DerivedKey, 64, 0);

    if (Status != 0)
    {
        //std::cout << "BCryptDeriveKeyPBKDF2 exited with error message " << Status;
        goto END;
    }

    //else
        //std::cout << "Operation completed successfully. Your encrypted key is in variable DerivedKey.";

    BCryptCloseAlgorithmProvider(handle, 0);

END:;
}

void test_good1()
{
    NTSTATUS Status;
    BYTE DerivedKey[64];

    BCRYPT_ALG_HANDLE handle;
    // GOOD hash handle generated here
    Status = BCryptOpenAlgorithmProvider(&handle, BCRYPT_SHA256_ALGORITHM, NULL, 0);

    if (Status != 0)
    {
        //std::cout << "BCryptOpenAlgorithmProvider exited with error message " << Status;
        goto END;
    }

    // GOOD Hash algorithm handle
    // GOOD salt length
    // GOOD iteration count
    // GOOD Key length
    Status = BCryptDeriveKeyPBKDF2(handle, (PUCHAR)password, strlen(password), (PUCHAR)salt, 64, 100000, (PUCHAR)DerivedKey, 64, 0);
    //Status = BCryptDeriveKeyPBKDF2(handle, (PUCHAR)password.data(), password.length(), (PUCHAR)salt.data(), 8, 2048, (PUCHAR)DerivedKey, 64, 0);

    if (Status != 0)
    {
        //std::cout << "BCryptDeriveKeyPBKDF2 exited with error message " << Status;
        goto END;
    }

    //else
        //std::cout << "Operation completed successfully. Your encrypted key is in variable DerivedKey.";

    BCryptCloseAlgorithmProvider(handle, 0);

END:;
}
