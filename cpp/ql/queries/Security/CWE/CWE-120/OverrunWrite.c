void sayHello()
{
	char buffer[10];

	// BAD: this message overflows the buffer
	strcpy(buffer, "Hello, world!");

	MessageBox(hWnd, buffer, "New Message", MB_OK);
}