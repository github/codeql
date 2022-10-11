fun test(
    p1: Map<String, String>,
    p2: AbstractMap<String, String>,
    p3: Collection<String>,
    p4: AbstractCollection<String>,
    p5: List<String>,
    p6: AbstractList<String>,
    p7: MutableMap<String, String>,
    p8: AbstractMutableMap<String, String>,
    p9: MutableCollection<String>,
    p10: AbstractMutableCollection<String>,
    p11: MutableList<String>,
    p12: AbstractMutableList<String>) {

    // Use a method of each to ensure method prototypes are extracted:
    p1.get("Hello");
    p2.get("Hello");
    p3.contains("Hello");
    p4.contains("Hello");
    p5.contains("Hello");
    p6.contains("Hello");
    p7.remove("Hello");
    p8.remove("Hello");
    p9.remove("Hello");
    p10.remove("Hello");
    p11.remove("Hello");
    p12.remove("Hello");

}
