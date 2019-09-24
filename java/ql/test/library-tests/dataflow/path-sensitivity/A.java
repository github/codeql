public class A {

	public static void sink(Object o) {
	}

	// false positive
	public void f1(boolean b) {
		Object x = null;
		if (b) {
			x = new Integer(6);
		}
		if (!b) {
			sink(x);
		}
	}

	// should exhibit flow (no call context available)
	public void f2(boolean b, boolean c) {
		Object x = null;
		if (b) {
			x = new Integer(6);
		}
		if (c) {
			b = !c; // false
		}
		if (!b) {
			sink(x);
		}
	}

	// false positive
	public void f3(boolean b, boolean c) {
		Object x = null;
		if (b) {
			if (c) {
				x = new Integer(6);
			}
		}
		if (!b) {
			if (c) {
				sink(x);
			}
		}
	}

	// false positive
	public void f4(boolean b, boolean c) {
		Object x = null;
		if (b) {
			if (!c) {
				x = new Integer(6);
			}
		}
		if (c) {
			sink(x);
		}
	}

	// false positive
	public void f5(boolean b, boolean c) {
		Object x = new Integer(6);
		Object j = null;
		if (c) {
			j = x;
		}
		if (!c) {
			sink(j);
		}
	}

	// false positive, but the sink is not guarded by a single condition variable so
	// we can't handle this case
	public void f6(boolean b, boolean c) {
		Object x = null;
		if (b && c) {
			x = new Integer(6);
		}

		if (!b || !c) {
			sink(x);
		}
	}

	// needs to detect flow, the example is of a class which is too complicated to
	// handle
	// - the condition variable for the branch tracking is assigned to in a loop
	public void f7() {
		Object x = null;
		int j = 0;
		boolean b;
		do {
			b = (j % 2) == 0;
			if (x == null) {
				if (b == true) {
					x = new Integer(1);
				}
			}
			j++;
		} while (j < 100);
		if (b == false) {
			sink(x);
		}
	}

	// false positive - variable write to b is always constant (i.e. could be
	// hoisted out of the loop)
	// However this is dead code, so it's not really interesting
	public void f8() {
		Object x = null;
		int j = 0;
		boolean b;
		do {
			b = false;
			if (x == null) {
				if (b == true) {
					x = new Integer(1);
				}
			}
			j++;
		} while (j < 100);
		if (b == false) {
			sink(x);
		}
	}

	// false positive, but needs to be detected as having flow,
	// because we have a dynamic condition and assign to the condition multiple
	// times. Thus, we learn nothing from the guard around the source here
	public void f9() {
		Object x = null;
		int j = 0;
		boolean b;
		do {
			b = j == 200;
			if (x == null) {
				if (b == true) {
					x = new Integer(1);
				}
			}
			j++;
		} while (j < 100);
		if (b == false) {
			sink(x);
		}
	}

	// false positive, because the code defining b before has a quite complicated
	// control flow,
	// but we only use b outside of loops, and after all control flow paths joined,
	// so it is constant
	// morally this should exhibit no flow
	public void f10(int c, boolean a) {
		Object x = null;
		boolean b = false;
		while (c < 100) {
			if (a) {
				b = true;
			} else {
				b = false;
			}
			c++;
		}
		if (b) {
			x = new Integer(4);
		}
		if (!b) {
			sink(x);
		}
	}

	// no flow expected
	public void f11(boolean b) {
		Object x = null;
		if (b) {
			x = new Integer(1);
		} else {
			sink(x);
		}
	}

	// false positive, because our approach fixes one fact
	// and then looks for contradicting facts - diamond paths like this
	// would require keeping a list of active facts
	public void f12(boolean b1, boolean b2) {
		Object x = null;
		if (!b1) {
			x = new Integer(1);
		}
		Object y = null;
		if (b1) {
			y = x;
		}
		if (b2) {
			y = x;
		}
		if (!b2) {
			sink(y);
		}
	}

	// false positive, where we would need to look at the actual CFG (not just the
	// dataflow graph) to learn about the property
	public void f13(boolean b) {
		Object x = new Integer(1);
		while (true) {
			if (b) {
				break;
			}
		}
		if (!b) {
			sink(x);
		}
	}

	// false positive, because everything happens inside a loop
	public void f14() {
		int j = 0;
		do {
			boolean b = j % 2 == 0;
			Object x = null;
			boolean c = !b;
			if (b) {
				x = new Integer(6);
			}
			if (!b) {
				sink(x);
			}
			j++;
		} while (j < 100);
	}

	// false positive
	public void f15(boolean b) {
		int j = 0;
		do {
			Object x = null;
			if (b) {
				x = new Integer(6);
			}
			if (!b) {
				sink(x);
			}
			j++;
		} while (j < 100);
	}

	// false positive
	// attempts to confuse the guard detection logic
	public void f16(int c, boolean a) {
		Object x = null;
		boolean b = false;
		do {
			if (a) {
				b = true;
			} else {
				b = false;
			}
			if (b) {
				c++;
			}
			c++;
		} while (c < 100);
		if (b) {
			x = new Integer(4);
		}
		if (!b) {
			sink(x);
		}
	}

	// false positive
	public void f17(boolean b) {
		int j = 0;
		do {
			Object x = null;
			if (b) {
				x = new Integer(6);
			}
			if (!b) {
				sink(x);
			}
			j++;
			b = j % 2 == 0;
		} while (j < 100);
	}

}
