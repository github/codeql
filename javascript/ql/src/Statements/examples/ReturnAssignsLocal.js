function Person(first, last, age) {
	this.first = first;
	this.last = last;
	this.age = age;
}

Person.prototype.getName = function() {
	var name = first + " " + last;
	return name = name.trim();
};