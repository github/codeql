import java.util.*;

public class ChainedInstanceof {
	public static void main(String[] args) {
		// BAD: example of a sequence of type tests
		List<BadAnimal> badAnimals = new ArrayList<BadAnimal>();
		badAnimals.add(new BadCat());
		badAnimals.add(new BadDog());
		for(BadAnimal a: badAnimals) {
			if(a instanceof BadCat)      System.out.println("Miaow!");
			else if(a instanceof BadDog) System.out.println("Woof!");
			else                         throw new RuntimeException("Oops!");
		}

		// GOOD: solution using polymorphism
		List<PolymorphicAnimal> polymorphicAnimals = new ArrayList<PolymorphicAnimal>();
		polymorphicAnimals.add(new PolymorphicCat());
		polymorphicAnimals.add(new PolymorphicDog());
		for(PolymorphicAnimal a: polymorphicAnimals) a.speak();

		// GOOD: solution using the visitor pattern
		List<VisitableAnimal> visitableAnimals = new ArrayList<VisitableAnimal>();
		visitableAnimals.add(new VisitableCat());
		visitableAnimals.add(new VisitableDog());
		for(VisitableAnimal a: visitableAnimals) a.accept(new SpeakVisitor());
	}

	//#################### TYPES FOR BAD EXAMPLE ####################

	private interface BadAnimal {}
	private static class BadCat implements BadAnimal {}
	private static class BadDog implements BadAnimal {}

	//#################### TYPES FOR POLYMORPHIC EXAMPLE ####################

	private interface PolymorphicAnimal {
		void speak();
	}
	private static class PolymorphicCat implements PolymorphicAnimal {
		public void speak() { System.out.println("Miaow!"); }
	}
	private static class PolymorphicDog implements PolymorphicAnimal {
		public void speak() { System.out.println("Woof!"); }
	}

	//#################### TYPES FOR VISITOR EXAMPLE ####################

	private interface Visitor {
		void visit(VisitableCat c);
		void visit(VisitableDog d);
	}
	private static class SpeakVisitor implements Visitor {
		public void visit(VisitableCat c) { System.out.println("Miaow!"); }
		public void visit(VisitableDog d) { System.out.println("Woof!"); }
	}
	private interface VisitableAnimal {
		void accept(Visitor v);
	}
	private static class VisitableCat implements VisitableAnimal {
		public void accept(Visitor v) { v.visit(this); }
	}
	private static class VisitableDog implements VisitableAnimal {
		public void accept(Visitor v) { v.visit(this); }
	}
}
