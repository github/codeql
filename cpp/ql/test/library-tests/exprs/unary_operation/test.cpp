
int main()
{
	int i;
	int *ip;

	i = +(-1);
	i++;
	ip = &i;
	*ip--;
	++i;
	--i;

	return 0;
}
