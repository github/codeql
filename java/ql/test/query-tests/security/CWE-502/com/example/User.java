package com.example;

public final class User {
    private String uid;
    private String name;

    public User() {
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }
       
    public String getName() {
        return name;
    }
       
    public void setName(String name) {
        this.name = name; 
    }

    public String toString() {
          return "User[ name = "+name+", uid: "+uid+ "]"; 
    } 
}
