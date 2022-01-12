package main;

public class A<T> {
    public void fn() {
        A<String> a0 = new A<String>();
        A<Integer> a1 = new A<Integer>();

        B<String> b0 = new B<String>();
        B<Integer> b1 = new B<Integer>();
    }
}
