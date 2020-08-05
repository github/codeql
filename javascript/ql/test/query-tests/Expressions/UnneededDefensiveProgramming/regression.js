function getDate() {
	var date;
	if (something()) {
		date = new Date();
	} else {
		return null;
	}
	console.log(date);
	return date && date.getTime(); // NOT OK
}

function isNotNullOrString(obj) {
  return obj != null && obj != undefined && // NOT OK
      typeof obj != 'string'; 
}
