void congratulateUser(const char *userName)
{
	char buffer[80];

	// BAD: this could overflow the buffer if the UserName is long
	sprintf(buffer, "Congratulations, %s!", userName);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}