<script>
import { mapGetters } from 'vuex';

export default {
    computed: {
        ...mapGetters(['taintedGetter', 'untaintedGetter'])
    },
    methods: {
        sinks() {
            sink(this.taintedGetter); // NOT OK
            sink(this.untaintedGetter); // OK
        }
    }
};
</script>