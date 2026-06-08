import json, re
from app import SPELL_LOCAL_TEXTS

with open('test_remote.json', 'r', encoding='utf-8') as f:
    json_text = f.read()

json_text = re.sub(r'"\s*\n\s*"([A-Za-z])', r'",\n"\g<1>', json_text)
json_text = re.sub(r',\s*}', '}', json_text)
json_text = re.sub(r',\s*]', ']', json_text)
actions_data = json.loads(json_text)

for action in actions_data:
    if action.get('ID') == 'SNOW_0017':
        raw_name = action.get('Name') or ''
        print('raw_name:', repr(raw_name))
        print('raw_name in SPELL_LOCAL_TEXTS:', raw_name in SPELL_LOCAL_TEXTS)
        if raw_name in SPELL_LOCAL_TEXTS:
            print('resolved:', SPELL_LOCAL_TEXTS.get(raw_name))
        
        # Test ID based resolution
        for cand in (f'!!SNOW_0017_NAME', f'SNOW_0017_NAME'):
            if cand in SPELL_LOCAL_TEXTS:
                print('cand resolved:', cand, SPELL_LOCAL_TEXTS.get(cand))
