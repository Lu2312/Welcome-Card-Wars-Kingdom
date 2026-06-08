import json, re

with open('data/db_ActionCards.json', 'r', encoding='utf-8') as f:
    text = f.read()

orig_data = json.loads(text)

t = re.sub(r'"\s*\n\s*"([A-Za-z])', r'",\n"\g<1>', text)
t = re.sub(r',\s*}', '}', t)
t = re.sub(r',\s*]', ']', t)

new_data = json.loads(t)
for o, n in zip(orig_data, new_data):
    if o.get('ID') != n.get('ID'):
        print('ID mismatch', o.get('ID'), n.get('ID'))
    if o.get('Name') != n.get('Name'):
        print('Name mismatch for', o.get('ID'), o.get('Name'), n.get('Name'))
