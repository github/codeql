
typedef struct
{
	int x, y;
} MyCoords;

int getX(MyCoords *coords);
void doSomething(void *something);

typedef struct
{
	char isTrue;
} MyBool;

void myTest_with_local_flow(MyBool *b, int pos)
{
	MyCoords coords = {0};

	if (b->isTrue) {
		goto next;
	}

next:
	coords.x = coords.y = pos + 1;
	// There is flow from `{0}` to `coords` in `&coords` on the next line.
	coords.x = getX(&coords);

	doSomething((void *)&pos);
}
