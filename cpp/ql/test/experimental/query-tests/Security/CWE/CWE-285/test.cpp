#include "../../../../../library-tests/dataflow/taint-tests/stl.h"

using namespace std;

#define PAM_SUCCESS 1

typedef struct pam_handle
{
};
int pam_start(std::string servicename, std::string username, int a, struct pam_handle **);
int pam_authenticate(struct pam_handle *, int e);
int pam_acct_mgmt(struct pam_handle *, int e);

bool PamAuthBad(const std::string &username_in,
                const std::string &password_in,
                std::string &authenticated_username)
{

    struct pam_handle *pamh = nullptr; /* pam session handle */

    const char *username = username_in.c_str();
    int err = pam_start("test", username,
                        0, &pamh);
    if (err != PAM_SUCCESS)
    {
        return false;
    }

    err = pam_authenticate(pamh, 0);
    if (err != PAM_SUCCESS)
        return err;

    return true;
}

bool PamAuthGood(const std::string &username_in,
                 const std::string &password_in,
                 std::string &authenticated_username)
{

    struct pam_handle *pamh = nullptr; /* pam session handle */

    const char *username = username_in.c_str();
    int err = pam_start("test", username,
                        0, &pamh);
    if (err != PAM_SUCCESS)
    {
        return false;
    }

    err = pam_authenticate(pamh, 0);
    if (err != PAM_SUCCESS)
        return err;

    err = pam_acct_mgmt(pamh, 0);
    if (err != PAM_SUCCESS)
        return err;
    return true;
}
