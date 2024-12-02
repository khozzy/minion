from flask import request, abort
from functools import wraps
import os
import dotenv

dotenv.load_dotenv()


EXPECTED_API_KEY = os.getenv("API_KEY")


def secured(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not EXPECTED_API_KEY:
            abort(500, "Server misconfigured: API_KEY environment variable is not set")

        auth_key = request.headers.get("X-Auth-Key")
        if auth_key != EXPECTED_API_KEY:
            abort(401, "Invalid API key")
        return f(*args, **kwargs)

    return decorated_function
