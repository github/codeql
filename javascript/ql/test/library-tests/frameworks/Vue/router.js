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
            ],
            props: route => ({
                x: route.query.x
            }),
        },
        {
            props: {
                x: route => route.query.x,
                y: route => route.query.y
            },
        },
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
