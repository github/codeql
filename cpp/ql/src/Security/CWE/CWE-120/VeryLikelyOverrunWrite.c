int sayHello(uint32_t userId)
{
	char buffer[17];

	if (userId > 9999) return USER_ID_OUT_OF_BOUNDS;

	// BAD: this message overflows the buffer if userId >= 1000,
	// as no space for the null terminator was accounted for
	sprintf(buffer, "Hello, user %d!", userId);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
	
	return SUCCESS;
}