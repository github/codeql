function getDate() {
	var date;
	if (something()) {
		date = new Date();
	} else {
		return null;
	}
	console.log(date);
	return date && date.getTime(); // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
}

function isNotNullOrString(obj) {
  return obj != null && obj != undefined && // $ Alert TODO-MISSING: Alert[js/comparison-between-incompatible-types] Alert[js/trivial-conditional]
      typeof obj != 'string'; 
}
