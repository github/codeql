
void func1() noexcept;
void func2() noexcept(true);
void func3() noexcept(false);
void func4() noexcept(func1);
void func5(void param() noexcept);

void func6() throw();
void func7() throw(int);
void func8() throw(char, int);
void func8() throw(char, int)
{
}

class c
{
	void func9() throw();
};
