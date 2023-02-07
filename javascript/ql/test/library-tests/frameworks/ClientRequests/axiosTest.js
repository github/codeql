
//Use of axios as a global variable instead of an imported module to make Ajax calls 
var testvar = function () {
    axios({
        method: 'get',
        url: url,
    }).then(function (response) {
        console.log(response.data) })



    axios({
        method: 'post',
        url: url,
        headers: { 'Content-Type': 'application/json' },
        data: {x: 'test', y:'test'}
    }).then(function (response) {
        console.log(response.data) })
}


