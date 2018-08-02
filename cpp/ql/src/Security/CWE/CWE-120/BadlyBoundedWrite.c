void congratulateUser(const char *userName)
{
	char buffer[80];

	// BAD: even though snprintf is used, this could overflow the buffer
	// because the size specified is too large.
	snprintf(buffer, 256, "Congratulations, %s!", userName);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}