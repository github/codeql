var x = require('x');

module.exports = {
	props: ['input'],
	data: function() { return { dataA: 42 + this.input } }
}
