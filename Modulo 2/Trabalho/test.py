# %%
from pymongo import MongoClient

client = MongoClient('localhost',27017)
db=client['aula']

# %%
db.livros.find().count()

# %%
from bson.json_util import dumps, loads
dumps(db.livros.find())
# %%
db.livros.insertMany([
{"title" : "Test Scheffer"},{"title" : "Test Scheffer2"}
])

# %%
