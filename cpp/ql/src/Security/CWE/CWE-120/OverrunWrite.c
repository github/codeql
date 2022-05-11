void sayHello(uint32_t userId)
{
	char buffer[18];

	// BAD: this message overflows the buffer if userId >= 10000
	sprintf(buffer, "Hello, user %d!", userId);

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}