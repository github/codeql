int score;
char grade;

// ...

if (score >= 90) {
    grade = 'A';
} else if (score >= 80) {
    grade = 'B';
} else if (score >= 70) {
    grade = 'C';
} else if (score >= 60) {
    grade = 'D';
  // BAD: No terminating 'else' clause
}
System.out.println("Grade = " + grade);