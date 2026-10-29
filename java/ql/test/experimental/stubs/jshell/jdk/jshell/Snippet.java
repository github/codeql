package jdk.jshell;

public abstract class Snippet {

	public enum Kind {

		IMPORT(true),

		TYPE_DECL(true),

		METHOD(true),

		VAR(true),

		EXPRESSION(false),

		STATEMENT(false),

		ERRONEOUS(false);

		private final boolean isPersistent;

        Kind(boolean isPersistent) {
        	this.isPersistent = isPersistent;
        }

        public boolean isPersistent() {
            return false;
        }
	}
}
