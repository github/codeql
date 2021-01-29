import { map, catchError } from 'rxjs/operators';

source()
    .pipe(
        map(x => x + 'foo'),
        map(x => x + 'bar'),
        catchError(err => {})
    )
    .subscribe(data => {
        sink(data)
    });
