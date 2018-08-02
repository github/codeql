
int f(int x) {
    switch(x) {
    case 1:
        return 2;
    case 2:
        break;
    default:
        return 3;
    }
    return 4;
}

void g(int y) {
	int i;

    switch (y) {
    case 1:
		break;
    case 2:
		{
		} break;
    case 3:
		i++;
		break;
    }
    
    switch (y) {
    }
    
    switch (y) {
	case 1:
		break;
	case 2:
		{
			break;
		}
	case 3:
		{
			{
				break;
			}
		}
	}

	switch (y) {
	case 1:
	case 2:
		return;
	case 3:
	}
}
