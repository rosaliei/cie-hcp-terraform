import json, sys
s = json.load(sys.stdin)
for r in s["resources"]:
    for i in r.get("instances", []):
        for k, v in i.get("attributes", {}).items():
            if isinstance(v, str) and "PRIVATE KEY-----" in v:
                print("%s.%s.%s: contains a private key (%d chars, plaintext)" % (r["type"], r["name"], k, len(v)))
for k, v in s.get("outputs", {}).items():
    if isinstance(v.get("value"), str) and "PRIVATE KEY-----" in v["value"]:
        print("outputs.%s: contains a private key, sensitive=%s (still plaintext in state)" % (k, v.get("sensitive")))
