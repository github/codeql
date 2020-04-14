from bottle import Bottle, route, request, post, run, default_app


app = Bottle()


@route('/routing/hello/<name>')
def hello(name):
    return "Handling {}: name={!r}".format(request.method, name)


@app.route('/app/routing/hello/<name>')
def app_hello(name):
    return "Handling {}: name={!r}".format(request.method, name)


@post('/post-method/<foo>')
def a_post(foo):
    return "Handling {}: foo={!r}".format(request.method, foo)


@app.post('/app/post-method/<foo>')
def an_app_post(foo):
    return "Handling {}: foo={!r}".format(request.method, foo)


@route('/wildcards/normal/<number>/<foo>')
def wildcards_normal(number, foo):
    return "Handling {}: number={!r}, foo={!r}".format(request.method, number, foo)

@route('/wildcards/with-filter/<number:int>/<foo:re:[a-z]+>')
def wildcards_with_filter(number, foo):
    return "Handling {}: number={!r}, foo={!r}".format(request.method, number, foo)

@route('/wildcards/deprecated/:number/:foo')
def wildcards_deprecated(number, foo):
    return "Handling {}: number={!r}, foo={!r}".format(request.method, number, foo)


@route # TODO: not recognized as route
def magic(name): # TODO: not recognized as HttpSource
    return "Handling {}: name={!r}".format(request.method, name) # TODO: not recognized as sink


def with_callback(name): # TODO: not recognized as HttpSource
    return "Handling {}: name={!r}".format(request.method, name) # TODO: not recognized as sink
route('/routing/with-callback/<name>', callback=with_callback) # TODO: not recognized as route


# you're not supposed to do this, but you can
def with_path_as_callable(name): # TODO: not recognized as HttpSource
    return "Handling {}: name={!r}".format (request.method, name) # TODO: not recognized as sink
route(with_path_as_callable) # TODO: not recognized as route


# Assigning multiple paths to the same handler # TODO: not recognized as route
@route(['/we-like/<animal>', '/we-like/<animal>/<color:re:[a-z]+>', '/we-like/<animal>/<times:int>'])
def we_like(animal, color="Unknown", times=None): # TODO: not recognized as HttpSource
    print(times, type(times))
    return "Handling {}: animal={!r}, color={!r}, times={!r}".format(request.method, animal, color, times)


# Assigning multiple paths to the same handler (by multiple decorators)
@route('/we-love/<animal>') # TODO: not recognized as route
@route('/we-love/<animal>/<color:re:[a-z]+>') # TODO: not recognized as route
@route('/we-love/<animal>/<times:int>')
def we_love(animal, color="Unknown", times=None): # TODO: color not recognized as HttpSource
    return "Handling {}: animal={!r}, color={!r}, times={!r}".format(request.method, animal, color, times)


if __name__ == '__main__':
    default = default_app()
    default.merge(app)
    run(default, host='localhost', port=8080, reloader=True)


# - http://localhost:8080/routing/hello/something

# - http://localhost:8080/app/routing/hello/foobar

# - http://localhost:8080/wildcards/normal/42/foobar

# - http://localhost:8080/wildcards/with-filter/42/foobar
# - http://localhost:8080/wildcards/with-filter/42a/foobar (404)
# - http://localhost:8080/wildcards/with-filter/42/foobar1 (404)

# - http://localhost:8080/wildcards/deprecated/42/foobar

# - http://localhost:8080/magic/WOW

# - http://localhost:8080/routing/with-callback/world

# - http://localhost:8080/with_path_as_callable/lol

# - http://localhost:8080/we-like/dog
# - http://localhost:8080/we-like/dog/blue
# - http://localhost:8080/we-like/dog/1000
# - http://localhost:8080/we-like/dog/ (404)
# - http://localhost:8080/we-like/dog/123abc (404)

# - http://localhost:8080/we-love/dog
# - http://localhost:8080/we-love/dog/blue
# - http://localhost:8080/we-love/dog/1000
# - http://localhost:8080/we-love/dog/ (404)
# - http://localhost:8080/we-love/dog/123abc (404)
