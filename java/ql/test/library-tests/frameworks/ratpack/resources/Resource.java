import ratpack.core.handling.Context;
import ratpack.core.http.TypedData;
import ratpack.core.form.Form;
import ratpack.core.form.UploadedFile;
import ratpack.core.parse.Parse;
import ratpack.exec.Operation;
import ratpack.exec.Promise;
import ratpack.exec.Result;
import ratpack.func.Action;
import ratpack.func.Function;
import java.io.OutputStream;

class Resource {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    void test1(Context ctx) {
        sink(ctx.getRequest().getContentLength()); //$hasTaintFlow
        sink(ctx.getRequest().getCookies()); //$hasTaintFlow
        sink(ctx.getRequest().oneCookie("Magic-Cookie")); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders()); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders().get("questionable_header")); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders().getAll("questionable_header")); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders().getNames()); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders().asMultiValueMap()); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders().asMultiValueMap().get("questionable_header")); //$hasTaintFlow
        sink(ctx.getRequest().getPath()); //$hasTaintFlow
        sink(ctx.getRequest().getQuery()); //$hasTaintFlow
        sink(ctx.getRequest().getQueryParams()); //$hasTaintFlow
        sink(ctx.getRequest().getQueryParams().get("questionable_parameter")); //$hasTaintFlow
        sink(ctx.getRequest().getRawUri()); //$hasTaintFlow
        sink(ctx.getRequest().getUri()); //$hasTaintFlow
    }

    void test2(Context ctx, OutputStream os) {
        ctx.getRequest().getBody().then(td -> {
            sink(td); //$hasTaintFlow
            sink(td.getText()); //$hasTaintFlow
            sink(td.getBuffer()); //$hasTaintFlow
            sink(td.getBytes()); //$hasTaintFlow
            sink(td.getContentType()); //$hasTaintFlow
            sink(td.getInputStream()); //$hasTaintFlow
            sink(os);
            td.writeTo(os);
            sink(os); //$hasTaintFlow
            if (td instanceof UploadedFile) {
                UploadedFile uf = (UploadedFile) td;
                sink(uf.getFileName()); //$hasTaintFlow
            }
        });
    }

    void test3(Context ctx) {
        ctx.getRequest().getBody().map(TypedData::getText).then(s -> {
            sink(s); //$hasTaintFlow
        });
        ctx.getRequest().getBody().map(b -> {
            sink(b); //$hasTaintFlow
            sink(b.getText()); //$hasTaintFlow
            return b.getText();
        }).then(t -> {
            sink(t); //$hasTaintFlow
        });
        ctx.getRequest().getBody().map(TypedData::getText).then(this::sink); //$hasTaintFlow
        ctx
            .getRequest()
            .getBody()
            .map(TypedData::getText)
            .next(this::sink) //$hasTaintFlow
            .then(this::sink); //$hasTaintFlow
    }

    void test4() {
        String tainted = taint();
        Promise.value(tainted);
        Promise
            .value(tainted)
            .then(this::sink); //$hasTaintFlow
        Promise
            .value(tainted)
            .map(a -> a)
            .then(this::sink); //$hasTaintFlow
    }

    void test5(Context ctx) {
        ctx
            .getRequest()
            .getBody()
            .map(data -> {
                Form form = ctx.parse(data, Form.form());
                sink(form); //$hasTaintFlow
                return form;
            })
            .then(form -> {
                sink(form.file("questionable_file")); //$hasTaintFlow
                sink(form.file("questionable_file").getFileName()); //$hasTaintFlow
                sink(form.files("questionable_files")); //$hasTaintFlow
                sink(form.files()); //$hasTaintFlow
                sink(form.get("questionable_parameter")); //$hasTaintFlow
                sink(form.getAll().get("questionable_parameter").get(0)); //$hasTaintFlow
                sink(form.getAll("questionable_parameter").get(0)); //$hasTaintFlow
                sink(form.asMultimap().get("questionable_parameter")); //$hasTaintFlow
                sink(form.asMultimap().asMap()); //$hasTaintFlow
                form.asMultimap().asMap().forEach((name, values) -> {
                    sink(name); //$hasTaintFlow
                    sink(values); //$hasTaintFlow
                });
            });
    }

    void test6(Context ctx) {
        ctx
            .parse(Parse.of(Form.class))
            .then(form -> {
                sink(form); //$hasTaintFlow
            });
        ctx
            .parse(Form.class)
            .then(form -> {
                sink(form); //$hasTaintFlow
            });
        ctx
            .parse(Form.class, "Some Object")
            .then(form -> {
                sink(form); //$hasTaintFlow
            });
    }

    void test7() {
        String tainted = taint();
        Promise
            .flatten(() -> Promise.value(tainted))
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .onError(Action.noop())
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .cache()
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .fork()
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .route(value -> {
                sink(value); //$hasTaintFlow
                return false;
            }, value -> {
                sink(value); //$hasTaintFlow
            })
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .cacheIf(value -> {
                sink(value); //$hasTaintFlow
                return true;
            })
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .onError(RuntimeException.class, Action.noop())
            .next(value -> {
                sink(value); //$hasTaintFlow
            })
            .map(value -> {
                sink(value); //$hasTaintFlow
                return value;
            })
            .blockingMap(value -> {
                sink(value); //$hasTaintFlow
                return value;
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    void test8() {
        String tainted = taint();
        Promise
            .sync(() -> tainted)
            .mapError(RuntimeException.class, exception -> {
                sink(exception); // no taint
                return "potato";
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value("potato")
            .mapError(RuntimeException.class, exception -> {
                return taint();
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value(tainted)
            .flatMapError(RuntimeException.class, exception -> {
                sink(exception); // no taint
                return Promise.value("potato");
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value("potato")
            .flatMapError(RuntimeException.class, exception -> {
                return Promise.value(taint());
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    void test9() {
        String tainted = taint();
        Promise
            .value(tainted)
            .map(Resource::identity)
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value("potato")
            .map(Resource::identity)
            .then(value -> {
                sink(value); // no taints flow
            });
        Promise
            .value(tainted)
            .flatMap(v -> Promise.value(v))
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    public static String identity(String input) {
        return input;
    }

    void test10() {
        String tainted = taint();
        Promise
            .value(tainted)
            .apply(Resource::promiseIdentity)
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value("potato")
            .apply(Resource::promiseIdentity)
            .then(value -> {
                sink(value); // no taints flow
            });
    }
    
    public static Promise<String> promiseIdentity(Promise<String> input) {
        return input.map(i -> i);
    }

    void test11() {
        String tainted = taint();
        Promise
            .value(tainted)
            .map(a -> a)
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .value("potato")
            .map(a -> a)
            .then(value -> {
                sink(value); // no taints flow
            });
    }

    void test12() {
        String tainted = taint();
        Promise
            .sync(() -> tainted)
            .mapIf(v -> {
                sink(v); //$hasTaintFlow
                return true;
            }, v -> {
                sink(v); //$hasTaintFlow
                return v;
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .sync(() -> tainted)
            .mapIf(v -> {
                sink(v); //$hasTaintFlow
                return true;
            }, vTrue -> {
                sink(vTrue); //$hasTaintFlow
                return vTrue;
            }, vFalse -> {
                sink(vFalse); //$hasTaintFlow
                return vFalse;
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
        Promise
            .sync(() -> tainted)
            .mapIf(v -> {
                sink(v); //$hasTaintFlow
                return true;
            }, vTrue -> {
                sink(vTrue); //$hasTaintFlow
                return "potato";
            }, vFalse -> {
                sink(vFalse); //$hasTaintFlow
                return "potato";
            })
            .then(value -> {
                sink(value); // no tainted flow
            });
    }

    void test13() {
        String tainted = taint();
        Promise
            .value(tainted)
            .replace(Promise.value("safe"))
            .then(value -> {
                sink(value); // no tainted flow
            });
        Promise
            .value("safe")
            .replace(Promise.value(tainted))
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    void test14() {
        String tainted = taint();
        Promise
            .value(tainted)
            .blockingOp(value -> {
                sink(value); //$hasTaintFlow
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    void test15() {
        String tainted = taint();
        Promise
            .value(tainted)
            .nextOp(value -> Operation.of(() -> {
                sink(value); //$hasTaintFlow
            }))
            .nextOpIf(value -> {
                sink(value); //$hasTaintFlow
                return true;
            }, value -> Operation.of(() -> {
                sink(value); //$hasTaintFlow
            }))
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

    void test16() {
        String tainted = taint();
        Promise
            .value(tainted)
            .flatOp(value ->  Operation.of(() -> {
                sink(value); //$hasTaintFlow
            }));
    }

    void test17() throws Exception {
        String tainted = taint();
        Result<String> result = Result.success(tainted);
        sink(result.getValue()); //$hasTaintFlow
        sink(result.getValueOrThrow()); //$hasTaintFlow
        Promise
            .value(tainted)
            .wiretap(r -> {
                sink(r.getValue()); //$hasTaintFlow
                sink(r.getValueOrThrow()); //$hasTaintFlow
            })
            .then(value -> {
                sink(value); //$hasTaintFlow
            });
    }

}
