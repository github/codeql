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
} else {  // GOOD: Terminating 'else' clause for all other scores
    grade = 'F';
}
System.out.println("Grade = " + grade);