import json
import behave2cucumber
import sys

fPath=str(sys.argv[1])
cucumber_json = None
with open(fPath) as behave_json:
    cucumber_json = behave2cucumber.convert(json.load(behave_json))

with open(fPath, "w") as of:
    json.dump(cucumber_json, of)