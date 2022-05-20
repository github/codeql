void printFellows(Set<Fellow> fellows) {
    for(Fellow f: fellows) {
        System.out.println(f);
    }
}

//...

void printRecords() {
    //...
    printFellows(fellows);
    printMembers(members);
    printAssociates(associates);
    printStudents(students);
}