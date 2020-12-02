
void computed_goto_test()
{
    void *ptr;
    int i = 0;

myLabel1:
	if (++i == 1)
	{
		ptr = &&myLabel1;
	} else {
		ptr = &&myLabel2;
	}
    goto *ptr;
myLabel2:
}
