abstract class Animal {
    private String animalName;

    public Animal(String name) {
        animalName = name;
    }

    public String getName() {  // Method has been pulled up into the base class.
        return animalName + " the " +  getKind();
    }

    public abstract String getKind();
}

class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }

    public String getKind() {
        return "dog";
    }
}

class Cat extends Animal {
    public Cat(String name) {
        super(name);
    }

    public String getKind() {
        return "cat";
    }
}
