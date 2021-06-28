import Vue from 'vue';
import Vuex from 'vuex';
import { mapGetters, mapState, mapMutations, mapActions } from 'vuex';

Vue.use(Vuex);

function sink(x) {}
function source() {}

const submoduleA = {
    getters: {
        foo: () => source(),
    }
};
const submoduleB = {
    getters: {
        foo: () => 'safe',
    }
};

const store = new Vuex.Store({
    getters: {
        getterWithSink: state => { sink(state.tainted); }, // NOT OK
        taintedGetter: state => state.tainted,
        untaintedGetter: state => state.untainted,
    },
    state: {
        tainted: '',
        tainted2: '',
        tainted3: '',
        tainted4: '',
        untainted: '',
        taintedAtSource: source(),
    },
    mutations: {
        setTainted: (state, payload) => {
            state.tainted = payload;
        },
        setTainted2: (state, payload) => {
            state.tainted2 = payload;
        },
        setTainted3: (state, payload) => {
            state.tainted3 = payload;
        },
        setTainted4: (state, payload) => {
            state.tainted4 = payload;
        },
        clean: (state, payload) => {
            state.untainted = payload;
        }
    },
    actions: {
        doTaint2(context, payload) {
            context.commit('setTainted2', payload);
        },
        doTaint4(context, payload) {
            context.commit('setTainted4', payload);
        },
    },
    modules: { submoduleA, submoduleB }
});

const Component = new Vue({
    computed: {
        ...mapGetters(['taintedGetter', 'untaintedGetter']),
        ...mapGetters({
            namedGetter: 'taintedGetter',
        }),
        ...mapState({
            localTainted: 'tainted',
            derivedTainted: state => state.tainted,
            derivedUntainted: state => state.untainted,
        }),
        ...mapState(['tainted2']),
        ...mapGetters('submoduleA', {fooA: 'foo'}),
        ...mapGetters('submoduleB', {fooB: 'foo'}),
    },
    methods: {
        doCommitsAndActions() {
            this.$store.commit('setTainted', source());
            this.$store.dispatch('doTaint2', source());
            this.$store.commit('clean', 'safe');
            this.sneakyTaint3(source());
            this.emitTaint4(source());
        },
        sinks() {
            sink(this.taintedGetter); // NOT OK
            sink(this.namedGetter); // NOT OK
            sink(this.$store.state.taintedAtSource); // NOT OK
            sink(this.$store.state.tainted3); // NOT OK
            sink(this.$store.state.tainted4); // NOT OK
            sink(this.localTainted); // NOT OK
            sink(this.derivedTainted); // NOT OK
            sink(this.tainted2); // NOT OK
            sink(this.untaintedGetter); // OK
            sink(this.derivedUntainted); // OK

            sink(this.fooA); // NOT OK
            sink(this.fooB); // OK
        },
        ...mapMutations({ sneakyTaint3: 'setTainted3' }),
        ...mapActions({ emitTaint4: 'doTaint4' }),
    }
});

const OtherComponent = new Vue({
    methods: {
        sinks() {
            // By being in the same file, `this.$store` is assumed to refer to the same vuex store as above.
            sink(this.$store.state.taintedAtSource); // NOT OK

            // This component has no `computed` helpers installed, so the following are all safe.
            sink(this.taintedGetter); // OK
            sink(this.namedGetter); // OK
            sink(this.localTainted); // OK
            sink(this.derivedTainted); // OK
            sink(this.tainted2); // OK
            sink(this.untaintedGetter); // OK
            sink(this.derivedUntainted); // OK
        }
    }
});
