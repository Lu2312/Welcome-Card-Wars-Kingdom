import urllib.request
import re
import json

try:
    print("Checking live site https://cardwars-kingdom.net/spells ...")
    req = urllib.request.Request(
        'https://cardwars-kingdom.net/spells',
        headers={'User-Agent': 'Mozilla/5.0'}
    )
    html = urllib.request.urlopen(req).read().decode('utf-8')
    
    rendered_ids = re.findall(r'data-id="([^"]*)"', html)
    rendered_costs = re.findall(r'data-cost="([^"]*)"', html)
    rendered_map = dict(zip(rendered_ids, rendered_costs))
    
    with open('data/db_ActionCards.json', encoding='utf-8') as f:
        cards = json.load(f)
    json_map = {c.get('ID', ''): str(c.get('Cost', '0')) for c in cards}
    
    mismatches = 0
    for card_id, json_cost in json_map.items():
        rendered_cost = rendered_map.get(card_id)
        if rendered_cost is None:
            continue
        if json_cost != rendered_cost:
            mismatches += 1
            print(f"MISMATCH on live site: ID={card_id} JSON={json_cost} Rendered={rendered_cost}")
            
    print(f"Total cards rendered on live site: {len(rendered_map)}")
    print(f"Total mismatches on live site: {mismatches}")
    if mismatches == 0:
        print("Success! Live site has correct costs for all cards!")
except Exception as e:
    print("Error:", e)
