#include "LibA/liba.h"
#include "LibB/libb.h"
#include "LibC/libc.h"
#include "include.h"

int main()
{
	libc::container<libb::thing> x; // LibB, LibC

	liba::fun(); // LibA

	return include_num;
}
