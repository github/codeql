# Annotated version
from mongosanitizer.sanitizer import sanitize

unsanitized_search = json.loads(request.args['search'])

sanitize(unsanitized_search)

db_results = mongo.db.user.find({'name': unsanitized_search})
