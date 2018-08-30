class Annotation {
    //...
}

void printAnnotation(Annotation annotation) {
    System.out.println("Message: " + annotation.getMessage());
    System.out.println("Line: " + annotation.getLine());
    System.out.println("Offset: " + annotation.getOffset());
    System.out.println("Length: " + annotation.getLength());
}