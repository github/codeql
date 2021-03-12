# merlyn

Similar to
[benjamin-button](https://github.com/github/codeql/blob/experimental/benjamin-button/benjamin-button.md),
this branch aims to approximate an older version of the CodeQL JavaScript libraries. While
benjamin-button removes support for recently added sinks, merlyn removes support for recently added
sources. The branches should be cleanly mergeable, allowing us to independently or jointly assess
the ability of an analysis technique to infer sources and sinks.

Like benjamin-button, merlyn focuses on `TaintedPath.ql`, `Xss.ql`, and `SqlInjection.ql` (which we
sometimes consider as two queries, one for SQL injection and one for NoSQL injection). We aim to
remove all sources added since 1 January 2020. This is also the cut-off date for `TaintedPath.ql` on
benjamin-button (the other queries have some even older sinks removed).

Surveying our three queries, we note that they all have `RemoteFlowSource` as their main kind of
taint source, with `Xss.ql` adding a few more sources besides. Below we detail how we rolled back
the changes to `RemoteFlowSource`, and then separately talk about the other sources in `Xss.ql`.

## `RemoteFlowSource`

We consider all transitive subclasses of `RemoteFlowSource`, remove those added since the cut-off
date entirely, and restore the other ones to their older state.

Here is the class hierarchy for `RemoteFlowSource`, with information about relevant changes to each subclass. The effects of these commits have been undone on this branch.

- `RemoteFlowSource`
  - `AngularSource`:
    introduced in [afd82e202d JS: Add Angular2 model](https://github.com/github/codeql/commit/afd82e202d)
  - `BusBoyRemoteFlow`:
    introduced in [a03f4ed3cd add remote flow source for `busboy`](https://github.com/github/codeql/commit/a03f4ed3cd)
  - `ClientRequestDataEvent`:
    modified in [0b55aed626 use the EventEmitter registration methods instead of just "on"](https://github.com/github/codeql/commit/0b55aed626)
  - `ClientRequestErrorEvent`:
    no relevant changes since the cut-off date
  - `ClientRequestLoginEvent`:
    no relevant changes since the cut-off date
  - `ClientRequestRedirectEvent`:
    no relevant changes since the cut-off date
  - `ClientRequestResponseEvent`:
    no relevant changes since the cut-off date
  - `ExternalRemoteFlowSource`:
    not relevant; this is for user-specified extra flow sources
  - `FirebaseVal`:
    no relevant changes since the cut-off date
  - `FormidableRemoteFlow`:
    introduced in [61b4ffec3d add remote flow from the `Formidable` library](https://github.com/github/codeql/commit/61b4ffec3d)
  - `LocationFlowSource`:
    no relevant changes since the cut-off date
  - `MicroBodyParserCall`:
    introduced in [4795b87daa JS: Add model of Micro](https://github.com/github/codeql/commit/4795b87daa)
  - `MultipartyRemoteFlow`:
    added in [010d580f8e add model for `multiparty`](https://github.com/github/codeql/commit/010d580f8e)
  - `NextParams`:
    introduced in [9d7bb57d8a add parameter values from Next as a RemoteFlowSource](https://github.com/github/codeql/commit/9d7bb57d8a)
  - `NodeJSNetServerItemAsRemoteFlow`:
    introduced in [082967a629 add EventEmitter models for `net.createServer()` and `respjs`.](https://github.com/github/codeql/commit/082967a629)
  - `PostMessageEventParameter`:
    indirectly modified in [cb7de2714a add `onmessage` handlers registered using global property as `PostMessageEventHandler`](https://github.com/github/codeql/commit/cb7de2714a)
  - `ReactRouterSource`:
    introduced in [d116b424f4 JS: Add model of react hooks and react-router](https://github.com/github/codeql/commit/d116b424f4)
  - `ReceivedItemAsRemoteFlow`:
    no relevant changes since the cut-off date
  - `RemoteFlowPassword`:
    not relevant; this is part of the heuristics library
  - `RemoteServerResponse`:
    not relevant; this is part of the heuristics library
  - `RequestInputAccess`:
    - `Connect::RequestInputAccess`:
      no relevant changes since the cut-off date
    - `Express::RequestInputAccess`: changed in
      - [e2fbf8a68c add files uploaded with `multer` as RemoteFlowSource](https://github.com/github/codeql/commit/e2fbf8a68c)
      - [89ef6ea4eb C++/C#/Java/JavaScript/Python: Autoformat set literals.](https://github.com/github/codeql/commit/89ef6ea4eb) (irrelevant, autoformat)
      - [83f0514475 add req.files as a RequestInputAccess in the Express model](https://github.com/github/codeql/commit/83f0514475)
      - [2b0a091921 split out type-tracking into two predicates, to avoid catastrophic join-order](https://github.com/github/codeql/commit/2b0a091921) (irrelevant, refactoring)
      - [ed48efe5b4 recognize access to a query object through function calls](https://github.com/github/codeql/commit/ed48efe5b4)
      - [d84f1b47c2 JS: Refactor RequestInputAccess to use source nodes](https://github.com/github/codeql/commit/d84f1b47c2)
      - [c45d84f8f3 JS: Update getRouteHandlerParameter and router tracking](https://github.com/github/codeql/commit/c45d84f8f3)
      - [9cacfab7c6 JS: Recognize Express param value callback as RemoteFlowSource](https://github.com/github/codeql/commit/9cacfab7c6)
    - `Fastify::RequestInputAccess`:
      added in [a76c70d2d7 JS: model fastify](https://github.com/github/codeql/commit/a76c70d2d7)
    - `Hapi::RequestInputAccess`:
      no relevant changes since the cut-off date
    - `Koa::RequestInputAccess`:
      no relevant changes since the cut-off date
    - `NodeJSLib::RequestInputAccess`
      no relevant changes since the cut-off date
    - `RequestHeaderAccess`:
      - `Express::RequestHeaderAccess`:
        no relevant changes since the cut-off date
      - `Fastify::RequestHeaderAccess`:
        added in [a76c70d2d7 JS: model fastify](https://github.com/github/codeql/commit/a76c70d2d7)
      - `Hapi::RequestHeaderAccess`:
        no relevant changes since the cut-off date
      - `Koa::RequestHeaderAccess`:
        no relevant changes since the cut-off date
      - `NodeJSLib::RequestHeaderAccess`:
        no relevant changes since the cut-off date
    - `Restify::RequestInputAccess`
      no relevant changes since the cut-off date
  - `RouteParamSource`:
    no relevant changes since the cut-off date
  - `ServerlessHandlerEventAsRemoteFlow`:
    introduced in [1ed026fcce add a RemoteFlowSource for serverless handlers](https://github.com/github/codeql/commit/1ed026fcce)
  - `ServerRequestDataEvent`:
    introduced in [4dec2171da add http request server data as a RemoteFlowSource](https://github.com/github/codeql/commit/4dec2171da)
  - `UserControlledTorrentInfo`:
    no relevant changes since the cut-off date
  - `VueRouterFlowSource`:
    introduced in [5264d24f34 JS: Model vue-router](https://github.com/github/codeql/commit/5264d24f34)
  - `WindowNameAccess`:
    no relevant changes since the cut-off date

## `Xss.ql`

The data-flow configuration was split and new sources were introduced in the following two commits:

- [c91cdb5194 JS: Address review comments](https://github.com/github/codeql/commit/c91cdb5194)
- [50a015c73e JS: Move $() sink into separate dataflow config](https://github.com/github/codeql/commit/50a015c73e)

Both commits have been reverted on this branch.
