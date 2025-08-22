using System;
using System.Collections;
using System.Collections.Generic;

class MissedCastOpportunity
{
    public void M1(List<Animal> animals)
    {
        // BAD: Can be replaced with animals.Cast<Dog>().
        foreach (Animal a in animals)
        {
            Dog d = (Dog)a;
            d.Woof();
        }
    }

    public void M2(NonEnumerableClass nec)
    {
        // GOOD: Not possible to use Linq here.
        foreach (Animal a in nec)
        {
            Dog d = (Dog)a;
            d.Woof();
        }
    }

    public void M3(Animal[] animals)
    {
        // BAD: Can be replaced with animals.Cast<Dog>().
        foreach (Animal animal in animals)
        {
            Dog d = (Dog)animal;
            d.Woof();
        }
    }

    public void M4(Array animals)
    {
        // BAD: Can be replaced with animals.Cast<Dog>().
        foreach (Animal animal in animals)
        {
            Dog d = (Dog)animal;
            d.Woof();
        }
    }

    public void M5(IEnumerable animals)
    {
        // BAD: Can be replaced with animals.Cast<Dog>().
        foreach (object animal in animals)
        {
            Dog d = (Dog)animal;
            d.Woof();
        }
    }

    public class NonEnumerableClass
    {
        public IEnumerator<Animal> GetEnumerator() => throw null;
    }

    public class Animal { }

    class Dog : Animal
    {
        private string name;

        public Dog(string name)
        {
            this.name = name;
        }

        public void Woof()
        {
            Console.WriteLine("Woof! My name is " + name + ".");
        }
    }
}