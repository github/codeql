public class A {
    private Object field;  
    
    public void setField(Object o){
        synchronized (field){    // BAD: synchronize on the field to be updated
            field = o;
            // ... more code ...          
        }
    }
}