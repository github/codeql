abstract class Animal {
    protected String animalName;

    public Animal(String name) {
        animalName = name;
    }

    public String getName(){
        return animalName;
    }
    public abstract String getKind();
}

class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }

    public String getName() {  // This method duplicates the method in class 'Cat'.
        return animalName + " the " +  getKind();
    }

    public String getKind() {
        return "dog";
    }
 }

class Cat extends Animal {
    public Cat(String name) {
        super(name);
    }

    public String getName() {  // This method duplicates the method in class 'Dog'.
        return animalName + " the " +  getKind();
    }

    public String getKind() {
        return "cat";
    }
}
