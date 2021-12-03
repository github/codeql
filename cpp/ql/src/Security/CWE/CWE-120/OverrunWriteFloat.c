void displayValue(double value)
{
	char buffer[256];

	// BAD: extreme values may overflow the buffer
	sprintf(buffer, "%f", value);

	MessageBox(hWnd, buffer, "A Number", MB_OK);
}