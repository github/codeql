var Vue = require('vue');

new Vue({
	render: function(ce) {
		return ce(a, b, c);
	},
	data: {
		dataA: 42
	}
});

new Vue({
	data: () => ({
		dataA: 42
	}),
});

Vue.component("my-component", {
	data: () => ({
		dataA: 42
	}),
	methods: {
		method: function() {
			this.dataB = true;
		}
	}
});

new Vue({
	computed: {
		x: () => 42,
		y: { get: () => 42 },
		z1: { set: function(){ this.z2 = 42; } }
	}
});

new Vue({
	template: danger
});

var Extended1 = Vue.extend({
  data: function () {
    return {
      fromSuper: 42
    };
  }
});
new Extended1({
	data: { fromSub: 42 }
});
var Extended2 = Vue.extend({
  data: function () {
    return {
      fromSuper: 42
    };
  }
});
new Vue({
	mixins: Extended2,
	data: { fromSub: 42 }
});

new Vue({
	mixins: [{data: { fromMixin1: 42 } }, {data: { fromMixin2: 42 } }],
	data: { fromSub: 42 }
});

var mixinData = { };
mixinData.fromMixinValue = 42;
var mixin = {data: mixinData };
var mixins = [mixin];
new Vue({
	mixins: mixins,
	data: { fromSub: 42 }
});

var DeadExtended = Vue.extend({
  data: function () {
    return {
      deadExtended: 42
    };
  }
});

new Vue({
	created: function(){ this.created = true; }
});
(function() {
	var data = { dataA: 42 };
	function f() {
		return data;
	}

	new Vue({
		data: f,
	});
});
(function() {
	new Vue({
		data: { dataA: 42 },
		methods: {
			m: function() { this.dataA; }
		}
	});
});
