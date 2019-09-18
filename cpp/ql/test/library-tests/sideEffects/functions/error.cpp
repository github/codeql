// semmle-extractor-options: --expect_errors

void functionBeforeError()
{
}

void functionWithError1()
{
	aaaaaaaaaa(); // error
}

void functionWithError2()
{
	int i = aaaaaaaaaa(); // error
}

void functionAfterError()
{
}
