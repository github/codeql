def lambda_handler(event, context):
    ensure_tainted(
        event, # $ tainted
        # event is usually a dict, see https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
        event["key"], # $ tainted
        event["key"]["key2"], # $ tainted
        event["key"][0], # $ tainted
        # but can also be a list
        event[0], # $ tainted
    )
    return "OK"
