/**
 * This library is used in the QL detective tutorials.
 *
 * Note: Data is usually stored in a separate database and the QL libraries only contain predicates,
 * but for this tutorial both the data and the predicates are stored in the library.
 */
class Person extends string {
  Person() {
    this =
      [
        "Ronil", "Dina", "Ravi", "Bruce", "Jo", "Aida", "Esme", "Charlie", "Fred", "Meera", "Maya",
        "Chad", "Tiana", "Laura", "George", "Will", "Mary", "Almira", "Susannah", "Rhoda",
        "Cynthia", "Eunice", "Olive", "Virginia", "Angeline", "Helen", "Cornelia", "Harriet",
        "Mahala", "Abby", "Margaret", "Deb", "Minerva", "Severus", "Lavina", "Adeline", "Cath",
        "Elisa", "Lucretia", "Anne", "Eleanor", "Joanna", "Adam", "Agnes", "Rosanna", "Clara",
        "Melissa", "Amy", "Isabel", "Jemima", "Cordelia", "Melinda", "Delila", "Jeremiah", "Elijah",
        "Hester", "Walter", "Oliver", "Hugh", "Aaron", "Reuben", "Eli", "Amos", "Augustus",
        "Theodore", "Ira", "Timothy", "Cyrus", "Horace", "Simon", "Asa", "Frank", "Nelson",
        "Leonard", "Harrison", "Anthony", "Louis", "Milton", "Noah", "Cornelius", "Abdul", "Warren",
        "Harvey", "Dennis", "Wesley", "Sylvester", "Gilbert", "Sullivan", "Edmund", "Wilson",
        "Perry", "Matthew", "Simba", "Nala", "Rafiki", "Shenzi", "Ernest", "Gertrude", "Oscar",
        "Lilian", "Raymond", "Elgar", "Elmer", "Herbert", "Maude", "Mae", "Otto", "Edwin",
        "Ophelia", "Parsley", "Sage", "Rosemary", "Thyme", "Garfunkel", "King Basil", "Stephen"
      ]
  }

  /** Gets the hair color of the person. If the person is bald, there is no result. */
  string getHairColor() {
    this = "Ronil" and result = "black"
    or
    this = "Dina" and result = "black"
    or
    this = "Ravi" and result = "black"
    or
    this = "Bruce" and result = "brown"
    or
    this = "Jo" and result = "red"
    or
    this = "Aida" and result = "blond"
    or
    this = "Esme" and result = "blond"
    or
    this = "Fred" and result = "gray"
    or
    this = "Meera" and result = "brown"
    or
    this = "Maya" and result = "brown"
    or
    this = "Chad" and result = "brown"
    or
    this = "Tiana" and result = "black"
    or
    this = "Laura" and result = "blond"
    or
    this = "George" and result = "blond"
    or
    this = "Will" and result = "blond"
    or
    this = "Mary" and result = "blond"
    or
    this = "Almira" and result = "black"
    or
    this = "Susannah" and result = "blond"
    or
    this = "Rhoda" and result = "blond"
    or
    this = "Cynthia" and result = "gray"
    or
    this = "Eunice" and result = "white"
    or
    this = "Olive" and result = "brown"
    or
    this = "Virginia" and result = "brown"
    or
    this = "Angeline" and result = "red"
    or
    this = "Helen" and result = "white"
    or
    this = "Cornelia" and result = "gray"
    or
    this = "Harriet" and result = "white"
    or
    this = "Mahala" and result = "black"
    or
    this = "Abby" and result = "red"
    or
    this = "Margaret" and result = "brown"
    or
    this = "Deb" and result = "brown"
    or
    this = "Minerva" and result = "brown"
    or
    this = "Severus" and result = "black"
    or
    this = "Lavina" and result = "brown"
    or
    this = "Adeline" and result = "brown"
    or
    this = "Cath" and result = "brown"
    or
    this = "Elisa" and result = "brown"
    or
    this = "Lucretia" and result = "gray"
    or
    this = "Anne" and result = "black"
    or
    this = "Eleanor" and result = "brown"
    or
    this = "Joanna" and result = "brown"
    or
    this = "Adam" and result = "black"
    or
    this = "Agnes" and result = "black"
    or
    this = "Rosanna" and result = "gray"
    or
    this = "Clara" and result = "blond"
    or
    this = "Melissa" and result = "brown"
    or
    this = "Amy" and result = "brown"
    or
    this = "Isabel" and result = "black"
    or
    this = "Jemima" and result = "red"
    or
    this = "Cordelia" and result = "red"
    or
    this = "Melinda" and result = "gray"
    or
    this = "Delila" and result = "white"
    or
    this = "Jeremiah" and result = "gray"
    or
    this = "Hester" and result = "black"
    or
    this = "Walter" and result = "black"
    or
    this = "Aaron" and result = "gray"
    or
    this = "Reuben" and result = "gray"
    or
    this = "Eli" and result = "gray"
    or
    this = "Amos" and result = "white"
    or
    this = "Augustus" and result = "white"
    or
    this = "Theodore" and result = "white"
    or
    this = "Timothy" and result = "brown"
    or
    this = "Cyrus" and result = "brown"
    or
    this = "Horace" and result = "brown"
    or
    this = "Simon" and result = "brown"
    or
    this = "Asa" and result = "brown"
    or
    this = "Frank" and result = "brown"
    or
    this = "Nelson" and result = "black"
    or
    this = "Leonard" and result = "black"
    or
    this = "Harrison" and result = "black"
    or
    this = "Anthony" and result = "black"
    or
    this = "Louis" and result = "black"
    or
    this = "Milton" and result = "blond"
    or
    this = "Noah" and result = "blond"
    or
    this = "Cornelius" and result = "red"
    or
    this = "Abdul" and result = "brown"
    or
    this = "Warren" and result = "red"
    or
    this = "Harvey" and result = "blond"
    or
    this = "Dennis" and result = "blond"
    or
    this = "Wesley" and result = "brown"
    or
    this = "Sylvester" and result = "brown"
    or
    this = "Gilbert" and result = "brown"
    or
    this = "Sullivan" and result = "brown"
    or
    this = "Edmund" and result = "brown"
    or
    this = "Wilson" and result = "blond"
    or
    this = "Perry" and result = "black"
    or
    this = "Simba" and result = "brown"
    or
    this = "Nala" and result = "brown"
    or
    this = "Rafiki" and result = "red"
    or
    this = "Shenzi" and result = "gray"
    or
    this = "Ernest" and result = "blond"
    or
    this = "Gertrude" and result = "brown"
    or
    this = "Oscar" and result = "blond"
    or
    this = "Lilian" and result = "brown"
    or
    this = "Raymond" and result = "brown"
    or
    this = "Elgar" and result = "brown"
    or
    this = "Elmer" and result = "brown"
    or
    this = "Herbert" and result = "brown"
    or
    this = "Maude" and result = "brown"
    or
    this = "Mae" and result = "brown"
    or
    this = "Otto" and result = "black"
    or
    this = "Edwin" and result = "black"
    or
    this = "Ophelia" and result = "brown"
    or
    this = "Parsley" and result = "brown"
    or
    this = "Sage" and result = "brown"
    or
    this = "Rosemary" and result = "brown"
    or
    this = "Thyme" and result = "brown"
    or
    this = "Garfunkel" and result = "brown"
    or
    this = "King Basil" and result = "brown"
    or
    this = "Stephen" and result = "black"
    or
    this = "Stephen" and result = "gray"
  }

  /** Gets the age of the person (in years). If the person is deceased, there is no result. */
  int getAge() {
    this = "Ronil" and result = 21
    or
    this = "Dina" and result = 53
    or
    this = "Ravi" and result = 16
    or
    this = "Bruce" and result = 35
    or
    this = "Jo" and result = 47
    or
    this = "Aida" and result = 26
    or
    this = "Esme" and result = 25
    or
    this = "Charlie" and result = 31
    or
    this = "Fred" and result = 68
    or
    this = "Meera" and result = 62
    or
    this = "Maya" and result = 29
    or
    this = "Chad" and result = 49
    or
    this = "Tiana" and result = 18
    or
    this = "Laura" and result = 2
    or
    this = "George" and result = 3
    or
    this = "Will" and result = 41
    or
    this = "Mary" and result = 51
    or
    this = "Almira" and result = 1
    or
    this = "Susannah" and result = 97
    or
    this = "Rhoda" and result = 39
    or
    this = "Cynthia" and result = 89
    or
    this = "Eunice" and result = 83
    or
    this = "Olive" and result = 25
    or
    this = "Virginia" and result = 52
    or
    this = "Angeline" and result = 22
    or
    this = "Helen" and result = 79
    or
    this = "Cornelia" and result = 59
    or
    this = "Harriet" and result = 57
    or
    this = "Mahala" and result = 61
    or
    this = "Abby" and result = 24
    or
    this = "Margaret" and result = 59
    or
    this = "Deb" and result = 31
    or
    this = "Minerva" and result = 72
    or
    this = "Severus" and result = 61
    or
    this = "Lavina" and result = 33
    or
    this = "Adeline" and result = 17
    or
    this = "Cath" and result = 22
    or
    this = "Elisa" and result = 9
    or
    this = "Lucretia" and result = 56
    or
    this = "Anne" and result = 11
    or
    this = "Eleanor" and result = 80
    or
    this = "Joanna" and result = 43
    or
    this = "Adam" and result = 37
    or
    this = "Agnes" and result = 47
    or
    this = "Rosanna" and result = 61
    or
    this = "Clara" and result = 31
    or
    this = "Melissa" and result = 37
    or
    this = "Amy" and result = 12
    or
    this = "Isabel" and result = 6
    or
    this = "Jemima" and result = 16
    or
    this = "Cordelia" and result = 21
    or
    this = "Melinda" and result = 55
    or
    this = "Delila" and result = 66
    or
    this = "Jeremiah" and result = 54
    or
    this = "Elijah" and result = 42
    or
    this = "Hester" and result = 68
    or
    this = "Walter" and result = 66
    or
    this = "Oliver" and result = 33
    or
    this = "Hugh" and result = 51
    or
    this = "Aaron" and result = 49
    or
    this = "Reuben" and result = 58
    or
    this = "Eli" and result = 70
    or
    this = "Amos" and result = 65
    or
    this = "Augustus" and result = 56
    or
    this = "Theodore" and result = 69
    or
    this = "Ira" and result = 1
    or
    this = "Timothy" and result = 54
    or
    this = "Cyrus" and result = 78
    or
    this = "Horace" and result = 34
    or
    this = "Simon" and result = 23
    or
    this = "Asa" and result = 28
    or
    this = "Frank" and result = 59
    or
    this = "Nelson" and result = 38
    or
    this = "Leonard" and result = 58
    or
    this = "Harrison" and result = 7
    or
    this = "Anthony" and result = 2
    or
    this = "Louis" and result = 34
    or
    this = "Milton" and result = 36
    or
    this = "Noah" and result = 48
    or
    this = "Cornelius" and result = 41
    or
    this = "Abdul" and result = 67
    or
    this = "Warren" and result = 47
    or
    this = "Harvey" and result = 31
    or
    this = "Dennis" and result = 39
    or
    this = "Wesley" and result = 13
    or
    this = "Sylvester" and result = 19
    or
    this = "Gilbert" and result = 16
    or
    this = "Sullivan" and result = 17
    or
    this = "Edmund" and result = 29
    or
    this = "Wilson" and result = 27
    or
    this = "Perry" and result = 31
    or
    this = "Matthew" and result = 55
    or
    this = "Simba" and result = 8
    or
    this = "Nala" and result = 7
    or
    this = "Rafiki" and result = 76
    or
    this = "Shenzi" and result = 67
  }

  /** Gets the height of the person (in cm). If the person is deceased, there is no result. */
  float getHeight() {
    this = "Ronil" and result = 183.0
    or
    this = "Dina" and result = 155.1
    or
    this = "Ravi" and result = 175.2
    or
    this = "Bruce" and result = 191.3
    or
    this = "Jo" and result = 163.4
    or
    this = "Aida" and result = 182.6
    or
    this = "Esme" and result = 176.9
    or
    this = "Charlie" and result = 189.7
    or
    this = "Fred" and result = 179.4
    or
    this = "Meera" and result = 160.1
    or
    this = "Maya" and result = 153.0
    or
    this = "Chad" and result = 168.5
    or
    this = "Tiana" and result = 149.7
    or
    this = "Laura" and result = 87.5
    or
    this = "George" and result = 96.4
    or
    this = "Will" and result = 167.1
    or
    this = "Mary" and result = 159.8
    or
    this = "Almira" and result = 62.1
    or
    this = "Susannah" and result = 145.8
    or
    this = "Rhoda" and result = 180.1
    or
    this = "Cynthia" and result = 161.8
    or
    this = "Eunice" and result = 153.2
    or
    this = "Olive" and result = 179.9
    or
    this = "Virginia" and result = 165.1
    or
    this = "Angeline" and result = 172.3
    or
    this = "Helen" and result = 163.1
    or
    this = "Cornelia" and result = 160.8
    or
    this = "Harriet" and result = 163.2
    or
    this = "Mahala" and result = 157.7
    or
    this = "Abby" and result = 174.5
    or
    this = "Margaret" and result = 165.6
    or
    this = "Deb" and result = 171.6
    or
    this = "Minerva" and result = 168.7
    or
    this = "Severus" and result = 188.8
    or
    this = "Lavina" and result = 155.1
    or
    this = "Adeline" and result = 165.5
    or
    this = "Cath" and result = 147.8
    or
    this = "Elisa" and result = 129.4
    or
    this = "Lucretia" and result = 153.6
    or
    this = "Anne" and result = 140.4
    or
    this = "Eleanor" and result = 151.1
    or
    this = "Joanna" and result = 167.2
    or
    this = "Adam" and result = 155.5
    or
    this = "Agnes" and result = 156.8
    or
    this = "Rosanna" and result = 162.4
    or
    this = "Clara" and result = 158.6
    or
    this = "Melissa" and result = 182.3
    or
    this = "Amy" and result = 147.1
    or
    this = "Isabel" and result = 121.4
    or
    this = "Jemima" and result = 149.8
    or
    this = "Cordelia" and result = 151.7
    or
    this = "Melinda" and result = 154.4
    or
    this = "Delila" and result = 163.4
    or
    this = "Jeremiah" and result = 167.5
    or
    this = "Elijah" and result = 184.5
    or
    this = "Hester" and result = 152.7
    or
    this = "Walter" and result = 159.6
    or
    this = "Oliver" and result = 192.4
    or
    this = "Hugh" and result = 173.1
    or
    this = "Aaron" and result = 176.6
    or
    this = "Reuben" and result = 169.9
    or
    this = "Eli" and result = 180.4
    or
    this = "Amos" and result = 167.4
    or
    this = "Augustus" and result = 156.5
    or
    this = "Theodore" and result = 176.6
    or
    this = "Ira" and result = 54.1
    or
    this = "Timothy" and result = 172.2
    or
    this = "Cyrus" and result = 157.9
    or
    this = "Horace" and result = 169.3
    or
    this = "Simon" and result = 157.1
    or
    this = "Asa" and result = 149.4
    or
    this = "Frank" and result = 167.2
    or
    this = "Nelson" and result = 173.0
    or
    this = "Leonard" and result = 172.0
    or
    this = "Harrison" and result = 126.0
    or
    this = "Anthony" and result = 98.4
    or
    this = "Louis" and result = 186.8
    or
    this = "Milton" and result = 157.8
    or
    this = "Noah" and result = 190.5
    or
    this = "Cornelius" and result = 183.1
    or
    this = "Abdul" and result = 182.0
    or
    this = "Warren" and result = 175.0
    or
    this = "Harvey" and result = 169.3
    or
    this = "Dennis" and result = 160.4
    or
    this = "Wesley" and result = 139.8
    or
    this = "Sylvester" and result = 188.2
    or
    this = "Gilbert" and result = 177.6
    or
    this = "Sullivan" and result = 168.3
    or
    this = "Edmund" and result = 159.2
    or
    this = "Wilson" and result = 167.6
    or
    this = "Perry" and result = 189.1
    or
    this = "Matthew" and result = 167.2
    or
    this = "Simba" and result = 140.1
    or
    this = "Nala" and result = 138.0
    or
    this = "Rafiki" and result = 139.3
    or
    this = "Shenzi" and result = 171.1
  }

  /** Gets the location of the person's home ("north", "south", "east", or "west"). If the person is deceased, there is no result. */
  string getLocation() {
    this = "Ronil" and result = "north"
    or
    this = "Dina" and result = "north"
    or
    this = "Ravi" and result = "north"
    or
    this = "Bruce" and result = "south"
    or
    this = "Jo" and result = "west"
    or
    this = "Aida" and result = "east"
    or
    this = "Esme" and result = "east"
    or
    this = "Charlie" and result = "south"
    or
    this = "Fred" and result = "west"
    or
    this = "Meera" and result = "south"
    or
    this = "Maya" and result = "south"
    or
    this = "Chad" and result = "south"
    or
    this = "Tiana" and result = "west"
    or
    this = "Laura" and result = "south"
    or
    this = "George" and result = "south"
    or
    this = "Will" and result = "south"
    or
    this = "Mary" and result = "south"
    or
    this = "Almira" and result = "south"
    or
    this = "Susannah" and result = "north"
    or
    this = "Rhoda" and result = "north"
    or
    this = "Cynthia" and result = "north"
    or
    this = "Eunice" and result = "north"
    or
    this = "Olive" and result = "west"
    or
    this = "Virginia" and result = "west"
    or
    this = "Angeline" and result = "west"
    or
    this = "Helen" and result = "west"
    or
    this = "Cornelia" and result = "east"
    or
    this = "Harriet" and result = "east"
    or
    this = "Mahala" and result = "east"
    or
    this = "Abby" and result = "east"
    or
    this = "Margaret" and result = "east"
    or
    this = "Deb" and result = "east"
    or
    this = "Minerva" and result = "south"
    or
    this = "Severus" and result = "north"
    or
    this = "Lavina" and result = "east"
    or
    this = "Adeline" and result = "west"
    or
    this = "Cath" and result = "east"
    or
    this = "Elisa" and result = "east"
    or
    this = "Lucretia" and result = "north"
    or
    this = "Anne" and result = "north"
    or
    this = "Eleanor" and result = "south"
    or
    this = "Joanna" and result = "south"
    or
    this = "Adam" and result = "east"
    or
    this = "Agnes" and result = "east"
    or
    this = "Rosanna" and result = "east"
    or
    this = "Clara" and result = "east"
    or
    this = "Melissa" and result = "west"
    or
    this = "Amy" and result = "west"
    or
    this = "Isabel" and result = "west"
    or
    this = "Jemima" and result = "west"
    or
    this = "Cordelia" and result = "west"
    or
    this = "Melinda" and result = "west"
    or
    this = "Delila" and result = "south"
    or
    this = "Jeremiah" and result = "north"
    or
    this = "Elijah" and result = "north"
    or
    this = "Hester" and result = "east"
    or
    this = "Walter" and result = "east"
    or
    this = "Oliver" and result = "east"
    or
    this = "Hugh" and result = "south"
    or
    this = "Aaron" and result = "south"
    or
    this = "Reuben" and result = "west"
    or
    this = "Eli" and result = "west"
    or
    this = "Amos" and result = "east"
    or
    this = "Augustus" and result = "south"
    or
    this = "Theodore" and result = "west"
    or
    this = "Ira" and result = "south"
    or
    this = "Timothy" and result = "north"
    or
    this = "Cyrus" and result = "north"
    or
    this = "Horace" and result = "east"
    or
    this = "Simon" and result = "east"
    or
    this = "Asa" and result = "east"
    or
    this = "Frank" and result = "west"
    or
    this = "Nelson" and result = "west"
    or
    this = "Leonard" and result = "west"
    or
    this = "Harrison" and result = "north"
    or
    this = "Anthony" and result = "north"
    or
    this = "Louis" and result = "north"
    or
    this = "Milton" and result = "south"
    or
    this = "Noah" and result = "south"
    or
    this = "Cornelius" and result = "east"
    or
    this = "Abdul" and result = "east"
    or
    this = "Warren" and result = "west"
    or
    this = "Harvey" and result = "west"
    or
    this = "Dennis" and result = "west"
    or
    this = "Wesley" and result = "west"
    or
    this = "Sylvester" and result = "south"
    or
    this = "Gilbert" and result = "east"
    or
    this = "Sullivan" and result = "east"
    or
    this = "Edmund" and result = "north"
    or
    this = "Wilson" and result = "north"
    or
    this = "Perry" and result = "west"
    or
    this = "Matthew" and result = "east"
    or
    this = "Simba" and result = "south"
    or
    this = "Nala" and result = "south"
    or
    this = "Rafiki" and result = "north"
    or
    this = "Shenzi" and result = "west"
  }

  /** Holds if the person is deceased. */
  predicate isDeceased() {
    this =
      [
        "Ernest", "Gertrude", "Oscar", "Lilian", "Edwin", "Raymond", "Elgar", "Elmer", "Herbert",
        "Maude", "Mae", "Otto", "Ophelia", "Parsley", "Sage", "Rosemary", "Thyme", "Garfunkel",
        "King Basil"
      ]
  }

  /** Gets a parent of the person (alive or deceased). */
  Person getAParent() {
    this = "Stephen" and result = "Edmund"
    or
    this = "Edmund" and result = "Augustus"
    or
    this = "Augustus" and result = "Stephen"
    or
    this = "Abby" and result = "Cornelia"
    or
    this = "Abby" and result = "Amos"
    or
    this = "Abdul" and result = "Susannah"
    or
    this = "Adam" and result = "Amos"
    or
    this = "Adeline" and result = "Melinda"
    or
    this = "Adeline" and result = "Frank"
    or
    this = "Agnes" and result = "Abdul"
    or
    this = "Aida" and result = "Agnes"
    or
    this = "Almira" and result = "Sylvester"
    or
    this = "Amos" and result = "Eunice"
    or
    this = "Amy" and result = "Noah"
    or
    this = "Amy" and result = "Chad"
    or
    this = "Angeline" and result = "Reuben"
    or
    this = "Angeline" and result = "Lucretia"
    or
    this = "Anne" and result = "Rhoda"
    or
    this = "Anne" and result = "Louis"
    or
    this = "Anthony" and result = "Lavina"
    or
    this = "Anthony" and result = "Asa"
    or
    this = "Asa" and result = "Cornelia"
    or
    this = "Cath" and result = "Harriet"
    or
    this = "Charlie" and result = "Matthew"
    or
    this = "Clara" and result = "Ernest"
    or
    this = "Cornelia" and result = "Cynthia"
    or
    this = "Cornelius" and result = "Eli"
    or
    this = "Deb" and result = "Margaret"
    or
    this = "Dennis" and result = "Fred"
    or
    this = "Eli" and result = "Susannah"
    or
    this = "Elijah" and result = "Delila"
    or
    this = "Elisa" and result = "Deb"
    or
    this = "Elisa" and result = "Horace"
    or
    this = "Esme" and result = "Margaret"
    or
    this = "Frank" and result = "Eleanor"
    or
    this = "Frank" and result = "Cyrus"
    or
    this = "George" and result = "Maya"
    or
    this = "George" and result = "Wilson"
    or
    this = "Gilbert" and result = "Cornelius"
    or
    this = "Harriet" and result = "Cynthia"
    or
    this = "Harrison" and result = "Louis"
    or
    this = "Harvey" and result = "Fred"
    or
    this = "Helen" and result = "Susannah"
    or
    this = "Hester" and result = "Edwin"
    or
    this = "Hugh" and result = "Cyrus"
    or
    this = "Hugh" and result = "Helen"
    or
    this = "Ira" and result = "Maya"
    or
    this = "Ira" and result = "Wilson"
    or
    this = "Isabel" and result = "Perry"
    or
    this = "Isabel" and result = "Harvey"
    or
    this = "Jemima" and result = "Melinda"
    or
    this = "Jemima" and result = "Frank"
    or
    this = "Ernest" and result = "Lilian"
    or
    this = "Ernest" and result = "Oscar"
    or
    this = "Gertrude" and result = "Ophelia"
    or
    this = "Gertrude" and result = "Raymond"
    or
    this = "Lilian" and result = "Elgar"
    or
    this = "Lilian" and result = "Mae"
    or
    this = "Raymond" and result = "Elgar"
    or
    this = "Raymond" and result = "Mae"
    or
    this = "Elmer" and result = "Ophelia"
    or
    this = "Elmer" and result = "Raymond"
    or
    this = "Herbert" and result = "Ophelia"
    or
    this = "Herbert" and result = "Raymond"
    or
    this = "Maude" and result = "Ophelia"
    or
    this = "Maude" and result = "Raymond"
    or
    this = "Otto" and result = "Elgar"
    or
    this = "Otto" and result = "Mae"
    or
    this = "Edwin" and result = "Otto"
    or
    this = "Parsley" and result = "Simon"
    or
    this = "Parsley" and result = "Garfunkel"
    or
    this = "Sage" and result = "Simon"
    or
    this = "Sage" and result = "Garfunkel"
    or
    this = "Rosemary" and result = "Simon"
    or
    this = "Rosemary" and result = "Garfunkel"
    or
    this = "Thyme" and result = "Simon"
    or
    this = "Thyme" and result = "Garfunkel"
    or
    this = "King Basil" and result = "Ophelia"
    or
    this = "King Basil" and result = "Raymond"
    or
    this = "Jo" and result = "Theodore"
    or
    this = "Joanna" and result = "Shenzi"
    or
    this = "Laura" and result = "Maya"
    or
    this = "Laura" and result = "Wilson"
    or
    this = "Lavina" and result = "Mahala"
    or
    this = "Lavina" and result = "Walter"
    or
    this = "Leonard" and result = "Cyrus"
    or
    this = "Leonard" and result = "Helen"
    or
    this = "Lucretia" and result = "Eleanor"
    or
    this = "Lucretia" and result = "Cyrus"
    or
    this = "Mahala" and result = "Eunice"
    or
    this = "Margaret" and result = "Cynthia"
    or
    this = "Matthew" and result = "Cyrus"
    or
    this = "Matthew" and result = "Helen"
    or
    this = "Maya" and result = "Meera"
    or
    this = "Melinda" and result = "Rafiki"
    or
    this = "Melissa" and result = "Mahala"
    or
    this = "Melissa" and result = "Walter"
    or
    this = "Nala" and result = "Bruce"
    or
    this = "Nelson" and result = "Mahala"
    or
    this = "Nelson" and result = "Walter"
    or
    this = "Noah" and result = "Eli"
    or
    this = "Olive" and result = "Reuben"
    or
    this = "Olive" and result = "Lucretia"
    or
    this = "Oliver" and result = "Matthew"
    or
    this = "Perry" and result = "Leonard"
    or
    this = "Ravi" and result = "Dina"
    or
    this = "Simba" and result = "Will"
    or
    this = "Simon" and result = "Margaret"
    or
    this = "Sullivan" and result = "Cornelius"
    or
    this = "Sylvester" and result = "Timothy"
    or
    this = "Theodore" and result = "Susannah"
    or
    this = "Tiana" and result = "Jo"
    or
    this = "Virginia" and result = "Helen"
    or
    this = "Warren" and result = "Shenzi"
    or
    this = "Wesley" and result = "Warren"
    or
    this = "Wesley" and result = "Jo"
    or
    this = "Will" and result = "Eli"
  }

  /** Holds if the person is allowed in the region. Initially, all villagers are allowed in every region. */
  predicate isAllowedIn(string region) { region = ["north", "south", "east", "west"] }
}

/** Returns a parent of the person. */
Person parentOf(Person p) { result = p.getAParent() }
