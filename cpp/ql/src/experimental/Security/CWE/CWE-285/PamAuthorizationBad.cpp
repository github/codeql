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

    err = pam_authenticate(pamh, 0); // BAD
    if (err != PAM_SUCCESS)
        return err;
    return true;
}
