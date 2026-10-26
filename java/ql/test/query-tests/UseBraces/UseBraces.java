



class UseBraces
{
	void f() { }
	void g() { }
	void h() { }
	void test(boolean bb)
	{
		int x = 0, y;
		int[] branches = new int[10];

		// If-then statement

		if(1==1)
		{
			f();
		}
			g();	// No alert

		if(1==1)
			f();
		g();		// No alert

		if(1==1)
			f(); // $ Alert
			g();

		if(1==1)
			f();	g();	// $ Alert

		// If-then-else statement

		if (1 + 2 == 3)
		{
			f();
		}
		else
		{
			g();
		}

			g();	// No alert

		if(1==2)
			f();
		else
			g();
		f();		// No alert

		if(true)
		{
			f();
		}
		else
			f(); // $ Alert
			g();

		if(true)
		{
			f();
		}
		else
			f();  g();	// $ Alert

		// While statement

		while(bb)
		{
			f();
		}
			g();		// No alert


		while(bb)
			f();
		g();

		while(bb   )
			f(); // $ Alert
			g();
			g();		// No alert

		while(bb   )
			f();	g();		// $ Alert


		while(bb)
			if (x != 0) x = 1;

		// Do-while statement

		do
			f();
		while(false);
			g();	// No alert

		// For statement
		for(int i=0; i<10; ++i)
		{
			f();
		}
			g();

		for(int i=0; i<10; ++i)
			f();
		g();

		for(int i=0; i<10; ++i)
			f(); // $ Alert
			g();

		for(int i=0; i<10; ++i)
			f(); g();			// $ Alert


		// Foreach statement

		for( int b : branches)
			x += b;
		f();

		for( int b : branches)
		{
			x += b;
		}
			f();

		for( int b : branches)
			f(); // $ Alert
			g();

		for( int b : branches)
			f(); g();		// $ Alert

		// Nested ifs
		if( true )
		if(false)
			f();
		g();	// No alert

		if( true )
			if(false) // $ Alert
				f();
			g();

		if( true )
			;
		else
		if (false)
			f();
		g();	// No alert

		if( true )
			;
		else
			if (false)
				f();
			g();  // $ MISSING: Alert // false negative

		if( true )
			;
		else if (false)
			f();  // $ Alert
			g();

		// Nested combinations
		if (true)
		while (x<10)
			f();
		g();	// No alert

		if (true)
			while (x<10) // $ Alert
				f();
			g();

		while (x<10)
		if (true)
			f();
		g();	// No alert

		while (x<10)
			if (true) // $ Alert
				f();
			g();

		if (true)
			f();
		class C {} // No alert

		if (true)
			f();
				g(); // No alert
	}
}
