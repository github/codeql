package com.thirdparty;

public class Person {
    private int snum;
    private String name;

    public Person() {
    }

    public int getSnum() {
        return snum;
    }

    public void setSnum(int snum) {
        this.snum = snum;
    }
       
    public String getName() {
        return name;
    }
       
    public void setName(String name) {
        this.name = name; 
    }

    public String toString() {
          return "Person[ name = "+name+", snum: "+snum+ "]"; 
    } 
}
