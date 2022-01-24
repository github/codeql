import * as consolidate from 'consolidate';

consolidate.ejs('views/instantiated_as_ejs.html', { data: 123 }, (err, html) => {});
consolidate.handlebars('views/instantiated_as_hbs.html', { data: 123 }, (err, html) => {});
