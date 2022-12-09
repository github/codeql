import javascript
import EndpointTypes as EndpointTypes

module ModelPrompt {
  pragma[inline]
  string getPrompt(DataFlow::Node endpoint) {
    result = getTrainingSetPrompt() + getCurrentEndpointPrompt(endpoint)
  }

  /**
   * Gets the beginning of the prompt, which contains the training examples, shuffled in random order.
   * This part of the prompt was generated from examples that come from training repos rather than evaluation repos.
   * These are diverse examples generated from a random selection of repos in the ATM training set.
   * Each example is from a different repo. There are two examples of each sink type and eight non-sink examples, each
   * from a different negative endpoint characteristic.
   */
  private string getTrainingSetPrompt() {
    result =
      "# Examples of security vulnerability sinks and non-sinks\n|Dataflow node|Neighborhood|Classification|\n|---|---|---|\n|`WPUrls.ajaxurl`|`            dataType:  json ,            type:  POST ,            url: WPUrls.ajaxurl,            data: data,            complete: function( json ) {`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`[ handlebars ]`|` use strict ;    if (typeof define ===  function  && define.amd) {        define([ handlebars ], function(Handlebars) {            return factory(Handlebars.default Handlebars);        });`|"
        + any(EndpointTypes::TaintedPathSinkType endpointType).getDescription() +
        "|\n|`url`|`} else {                        var matcher = new RegExp($.map(items.wanikanify_blackList, function(val) { return  ( +val+ ) ;}).join(  ));                        return matcher.test(url);                    }                }`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`_.bind(connection.createGame, this, socket)`|`var connection = module.exports = function (socket) {  socket.on( game:create , _.bind(connection.createGame, this, socket));  socket.on( game:spectate , _.bind(game.spectate, this, socket));  socket.on( register , _.bind(connection.register, this, socket));`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`sql`|`    if (err) throw err;    const sql =  UPDATE customers SET address =  Canyon 123  WHERE address =  Valley 345  ;    con.query(sql, function (err, result) {        if (err) throw err;        console.log(result.affectedRows +   record(s) updated );`|"
        + any(EndpointTypes::SqlInjectionSinkType endpointType).getDescription() +
        "|\n|` <style type= text/css  id= shapely-style-  + sufix +    /> `|`              if ( ! style.length ) {                style = $(  head  ).append(  <style type= text/css  id= shapely-style-  + sufix +    />  ).find(  #shapely-style-  + sufix );              }`|"
        + any(EndpointTypes::XssSinkType endpointType).getDescription() +
        "|\n|`content`|`  textBoxEditor(content) {    console.log(content);  }  ngOnInit() {`|" +
        any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`imageURL`|`            <div id =  mypost >                <Link to ={ /post?id=  + postId}>                    <img src={imageURL} alt=  />                    <div className= img_info >                        <div><i className= fas fa-heart ></i> <span id= likes >{this.state.like}</span></div>`|"
        + any(EndpointTypes::XssSinkType endpointType).getDescription() +
        "|\n|`{ roomId }`|`    }    const game = await Game.findOne({ roomId });    if (!game) {`|" +
        any(EndpointTypes::NosqlInjectionSinkType endpointType).getDescription() +
        "|\n|` SELECT owner, name, program FROM Programs WHERE name =    + data +    `|`app.get( /getProgram/:nombre , (request, response) => { var data = request.query.nombre; db.each( SELECT owner, name, program FROM Programs WHERE name =    + data +    , function(err, row) {     response.json(row.program); });`|"
        + any(EndpointTypes::SqlInjectionSinkType endpointType).getDescription() +
        "|\n|`listenToServer`|`                            processCommand(cmd);                        }     setTimeout(listenToServer, 0);                    }                }`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`negativeYearString`|`            return Date.prototype.toJSON                && new Date(NaN).toJSON() === null                && new Date(negativeDate).toJSON().indexOf(negativeYearString) !== -1                && Date.prototype.toJSON.call({ // generic                    toISOString: function () { return true; }`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`__dirname`|`fs  .readdirSync(__dirname)  .filter(function(file) {    return (file.indexOf( . ) !== 0) && (file !== basename);`|"
        + any(EndpointTypes::TaintedPathSinkType endpointType).getDescription() +
        "|\n|`certificateId`|`app.get( /certificate/data/:id , (req, res) => {  let certificateId = req.params.id;  Certificates.findById(certificateId)    .then(obj => {      if (obj === null)`|"
        + any(EndpointTypes::NosqlInjectionSinkType endpointType).getDescription() +
        "|\n|`{encoding:  utf8 }`|`function updateChangelog() {  var filename = path.resolve(__dirname,  ../CHANGELOG.md )    , changelog = fs.readFileSync(filename, {encoding:  utf8 })    , entry = new RegExp( ### (  + version +  )(?: \\((.+?)\\))\\n )`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() +
        "|\n|`depth`|` }); const indent =    .repeat(depth); let sep = indent; column_sizes.forEach((size) => {`|"
        + any(EndpointTypes::NegativeType endpointType).getDescription() + "|\n"
  }

  /**
   * Gets the last line of the prompt, containing the current endpoint.
   * TODO
   */
  private string getCurrentEndpointPrompt(DataFlow::Node endpoint) {
    result = "|`" + tokenizeEndpoint(endpoint) + "`|`" + tokenizeNeighborhood(endpoint, 2) + "`|"
  }

  /**
   * Gets the reconstructed source code text for a range of locations.
   * TODO: This excludes comments
   * TODO: Don't add a space if the current or previous token is a period.
   */
  string tokenize(Location location) {
    result =
      strictconcat(Token token |
        location.containsLoosely(token.getLocation())
      |
        token
                .getValue()
                .replaceAll("\"", " ")
                .replaceAll("\\", " ")
                .replaceAll("\n", " ")
                .replaceAll("\r", " ")
                .replaceAll("|", " ")
                .replaceAll("`", " ") +
            // Use space as the separator, since that is most likely.
            // May not be an exact reconstruction, e.g. if the code
            // had newlines between successive tokens.
            " "
        order by
          token.getLocation().getStartLine(), token.getLocation().getStartColumn()
      )
  }

  /**
   * Gets the reconstructed source code text for `node`.
   */
  string tokenizeEndpoint(DataFlow::Node node) {
    result = tokenize(node.getAstNode().getLocation())
  }

  /**
   * Gets the reconstructed source code text for the neighborhood around `node`, including `neighborhoodSize` lines
   * before and `neighborhoodSize` lines after `node`.
   */
  bindingset[neighborhoodSize]
  string tokenizeNeighborhood(DataFlow::Node node, int neighborhoodSize) {
    result =
      tokenize(max(Location loc |
          // Select the largest neighborhood that contains `node` and at most `neighborhoodSize` lines before and after
          // `node`.
          loc.getFile() = node.getAstNode().getLocation().getFile() and
          loc.containsLoosely(node.getAstNode().getLocation()) and
          loc.getStartLine() >= node.getAstNode().getLocation().getStartLine() - neighborhoodSize and
          loc.getEndLine() <= node.getAstNode().getLocation().getEndLine() + neighborhoodSize
            |
          loc
          order by
            loc.getNumLines(), loc.getEndColumn() - loc.getStartColumn(), loc.getEndColumn(),
            loc.getStartColumn() desc
        ))
  }
}
