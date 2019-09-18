import java.io.Closeable;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class PartiallyMaskedCatchTest {

	public static void method() {

		try(ClosableThing thing = new ClosableThing()){
			thing.doThing();
		} catch (ExceptionB e) {
			// reachable: ExceptionB is thrown by invocation of CloseableThing.doThing()
		} catch (ExceptionA e) {
			// reachable: ExceptionA is thrown by implicit invocation of CloseableThing.close()
		} catch (IOException e) {
			// unreachable: only more specific exceptions are thrown and caught by previous catch blocks
		}

		try(ClosableThing thing = new ClosableThing()){
			thing.doThing();
		} catch (ExceptionB | NullPointerException e) {
			// reachable: ExceptionB is thrown by invocation of CloseableThing.doThing()
		} catch (ExceptionA | RuntimeException e) {
			// reachable: ExceptionA is thrown by implicit invocation of CloseableThing.close()
		} catch (IOException e) {
			// unreachable: only more specific exceptions are thrown and caught by previous catch blocks
		}

		try(ClosableThing thing = new ClosableThing()){
			thing.doThing();
		} catch (ExceptionB | NullPointerException e) {
			// reachable: ExceptionB is thrown by invocation of CloseableThing.doThing()
		} catch (ExceptionA | IllegalArgumentException e) {
			// reachable: ExceptionA is thrown by implicit invocation of CloseableThing.close()
		} catch (IOException | RuntimeException e) {
			// unreachable for type IOException: only more specific exceptions are thrown and caught by previous catch blocks
		}

		try {
			throwingMethod();
		} catch (ClassNotFoundException e) {
			throw new IllegalArgumentException("");
		} catch (NoSuchMethodException | InstantiationException | IllegalAccessException e) {
			throw new IllegalArgumentException("");
		} catch (InvocationTargetException ite) {
			throw new IllegalStateException("");
		}

		try {
			Class<?> clazz = Class.forName("", true, null).asSubclass(null);
			Constructor<?> constructor = clazz.getConstructor();
			constructor.newInstance();
		} catch (ClassNotFoundException e) {
			throw new IllegalArgumentException("");
		} catch (NoSuchMethodException | InstantiationException | IllegalAccessException e) {
			throw new IllegalArgumentException("");
		} catch (InvocationTargetException ite) {
			throw new IllegalStateException("");
		}

		try(ClosableThing thing = getClosableThing()){
			thing.doThing();
		} catch (ExceptionB e) {
			// reachable: ExceptionB is thrown by invocation of CloseableThing.doThing()
		} catch (ExceptionA e) {
			// reachable: ExceptionA is thrown by implicit invocation of CloseableThing.close()
		} catch (IOException e) {
			// reachable: IOException is thrown by getClosableThing()
		}

		try (ClosableThing thing = new ClosableThing()) {
			genericThrowingMethod(IOException.class);
		} catch (ExceptionA e) {
			// reachable: ExceptionA is thrown by implicit invocation of CloseableThing.close()
		} catch (IOException e) {
			// reachable: IOException is thrown by invocation of genericThrowingMethod(IOException.class)
		}
	}

	public static ClosableThing getClosableThing() throws IOException {
		return new ClosableThing();
	}

	public static class ClosableThing implements Closeable {

		@Override
		public void close() throws ExceptionA {}

		public void doThing() throws ExceptionB {}
	}

	public static class ExceptionA extends IOException {
		private static final long serialVersionUID = 1L;
	}

	public static class ExceptionB extends ExceptionA {
		private static final long serialVersionUID = 1L;
	}

	public static void throwingMethod()
			throws ClassNotFoundException,
			NoSuchMethodException, InstantiationException, IllegalAccessException,
			InvocationTargetException {}

	public static <E extends Exception> void genericThrowingMethod(Class<E> c) throws E {}
}
