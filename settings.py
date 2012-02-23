# Global settings

try:
    from newebe.local_settings import *
except:
    TORNADO_PORT = 8000
    COUCHDB_DB_NAME = "newebe"
    DEBUG = False
    TIMEZONE = "GMT"
    COOKIE_KEY = "61oETzKXQAGaYdkL5gEmGeJJFuYh7EQnp2XdTP1o/Vo="




# Couchdb configuration
COUCHDB_DB_URI =  'http://127.0.0.1:5984/%s' % COUCHDB_DB_NAME
COUCHDB_DATABASES = (
    ('newebe.news', COUCHDB_DB_URI),
    ('newebe.core', COUCHDB_DB_URI),
    ('newebe.activities', COUCHDB_DB_URI),
    ('newebe.notes', COUCHDB_DB_URI),
    ('newebe.pictures', COUCHDB_DB_URI),
)

INSTALLED_APPS = (
    'newebe.core',
    'newebe.activities',
    'newebe.news',
    'newebe.notes',
    'newebe.pictures',
)

