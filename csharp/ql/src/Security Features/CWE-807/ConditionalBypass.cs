public boolean doLogin(HttpCookie adminCookie, String user, String password)
{

    // BAD: login is executed only if the value of 'adminCookie' is 'false',
    // but 'adminCookie' is controlled by the user
    if (adminCookie.Value == "false")
        return login(user, password);

    return true;
}

public boolean doLogin(HttpCookie adminCookie, String user, String password)
{
    // GOOD: use server-side information based on the credentials to decide
    // whether user has privileges
    bool isAdmin = queryDbForAdminStatus(user, password);
    if (!isAdmin)
        return login(user, password);

    return true;
}
