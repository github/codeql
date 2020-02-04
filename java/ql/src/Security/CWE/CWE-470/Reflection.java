// BAD: class_name is user contoller input
String class_name = System.getenv("CLASS_NAME");
Class class = Class.forName(class_name);

// GOOD: use string constant
String class_name = "awt";
Class class = Class.forName(class_name);