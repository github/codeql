void printMembership(Set<Fellow> fellows, Set<Member> members, 
                     Set<Associate> associates, Set<Student> students) {
    for(Fellow f: fellows) {
        System.out.println(f);
    }
    for(Member m: members) {
        System.out.println(m);
    }
    for(Associate a: associates) {
        System.out.println(a);
    }
    for(Student s: students) {
        System.out.println(s);
    }
}

void printRecords() {
    //...
    printMembership(fellows, members, associates, students);
}