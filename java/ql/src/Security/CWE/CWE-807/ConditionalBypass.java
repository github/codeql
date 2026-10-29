public boolean doLogin(String user, String password) {
	Cookie adminCookie = getCookies()[0];

	// BAD: login is executed only if the value of 'adminCookie' is 'false', 
	// but 'adminCookie' is controlled by the user
	if(adminCookie.getValue()=="false")
		return login(user, password);
	
	return true;
}

public boolean doLogin(String user, String password) {
	Cookie adminCookie = getCookies()[0];
	
	// GOOD: use server-side information based on the credentials to decide
	// whether user has privileges
	boolean isAdmin = queryDbForAdminStatus(user, password);
	if(!isAdmin)
		return login(user, password);
	
	return true;
}