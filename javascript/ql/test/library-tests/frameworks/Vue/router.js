import Router from 'vue-router';

export const router = new Router({
    routes: [
        {
            path: '/foo',
            beforeEnter: (to, from, next) => {
                to.query.x;
                from.query.x;
            },
            children: [
                {
                    path: '/bar',
                    beforeEnter: (to, from, next) => {
                        to.query.x;
                        from.query.x;
                    }
                }
            ]
        }
    ],
    scrollBehavior(to, from, savedPosition) {
        to.query.x;
        from.query.x;
    }
});

router.beforeEach((to, from, next) => {
    to.query.x;
    from.query.x;
});

router.afterEach((to, from) => {
    to.query.x;
    from.query.x;
});

