
void test(int x) {
	int y = 0;

	switch (x)
	{
	case 1:
		break;
	case 2:
	case 3:
		[[clang::fallthrough]];

	case 4:
		y++;
		break;
	case 5:
		y++;
	case 6:
		y++;
		[[clang::fallthrough]];
	case 7:
		[[clang::fallthrough]];
		y++;

	case 8:
		{
			y++;
		} break;
	case 9:
		{
			y++;
		}
	case 10:
		{
			y++;
			[[clang::fallthrough]];
		}
	case 11:
		{
			y++;
		} [[clang::fallthrough]];
	default:
		[[clang::fallthrough]];
	}
}
