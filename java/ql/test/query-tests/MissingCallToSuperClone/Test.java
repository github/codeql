class IAmAGoodCloneable implements Cloneable {
	public Object clone() {
		return super.clone();
	}
}

class Sub1 extends IAmAGoodCloneable { public Object clone() { return super.clone(); } }

class IAmABadCloneable implements Cloneable {
	public Object clone() {
		return null;
	}
}

class Sub2 extends IAmABadCloneable { public Object clone() { return super.clone(); } }

class IMayBeAGoodCloneable implements Cloneable {
	public native Object clone();
}

class Sub3 extends IMayBeAGoodCloneable { public Object clone() { return super.clone(); } }
