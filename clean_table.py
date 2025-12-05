import re

# Read the file
with open('templates/Dungeons _ Card Wars Kingdom Wikia _ Fandom.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the table
start = content.find('<table')
end = content.find('</table>', start) + len('</table>')

table_html = content[start:end]

# Clean the table: remove <span typeof="mw:File"> <a ...> </a> </span> around img
table_html = re.sub(r'<span typeof="mw:File"><a[^>]*>','', table_html)
table_html = re.sub(r'</a></span>','', table_html)

# Also for the th with img
table_html = re.sub(r'<span typeof="mw:File"><a[^>]*><img[^>]*></a></span>','', table_html)

# Now, the img src are like src="./Dungeons _ Card Wars Kingdom Wikia _ Fandom_files/Beetle_Butter.webp"

# But to use dungeon_archivos, and since the images are the same as in the current dungeon.html, but the current uses image001.png for Beetle Butter, etc.

# So, to map, I can replace the src with the corresponding imageXXX.png

# But since the alt is the item name, I can map based on alt.

# But easier, since the order is the same, I can replace all img src with the sequential from the list.

# The images in order are the same as in the filelist for the current dungeon.html.

# So, the first img is for Beetle Butter, src should be dungeon_archivos/image001.png

# Second for Half Eaten Sandwich, image002.png

# Etc.

# So, I can replace the src with the corresponding.

# But since there are many, I can use a counter.

# First, remove the src="./Dungeons _ Card Wars Kingdom Wikia _ Fandom_files/..." and replace with dungeon_archivos/imageXXX.png

# But to do that, I need to know which XXX.

# Since the alt is the item name, and I have the mapping from item to image.

# But to make it simple, since the order is the same as in the current table, I can use the same list.

# The weekly items are the same as in the current dungeon.html.

# So, the mapping is the same.

# I can replace the img tag with <img src="dungeon_archivos/imageXXX.png" alt="item" width="75" height="75">

# Using the list.

# Let's define the list again.

weekly_images = [
    'image001.png', 'image002.png', 'image003.png', 'image050.jpg', 'image005.png', 'image006.png', 'image007.png',
    'image008.png', 'image009.png', 'image010.png', 'image011.png', 'image051.jpg', 'image013.png', 'image014.png',
    'image015.png', 'image016.png', 'image017.png', 'image052.jpg', 'image019.png', 'image020.png', 'image021.png',
    'image022.png', 'image023.png', 'image024.png', 'image053.png', 'image026.png', 'image027.png', 'image028.png'
]

snack_images = [
    'image054.png', 'image030.png',
    'image031.png', 'image055.jpg',
    'image056.jpg', 'image034.png',
    'image035.png', 'image036.png'
]

all_images = weekly_images + snack_images

# Now, replace each <img ...> with the corresponding

def replace_img(match):
    if not hasattr(replace_img, 'counter'):
        replace_img.counter = 0
    index = replace_img.counter
    replace_img.counter += 1
    if index < len(all_images):
        img_tag = match.group(0)
        # Get the alt
        alt_match = re.search(r'alt="([^"]*)"', img_tag)
        if alt_match:
            alt = alt_match.group(1)
            image = all_images[index]
            return f'<img src="dungeon_archivos/{image}" alt="{alt}" width="75" height="75">'
    return match.group(0)

table_html = re.sub(r'<img[^>]*>', replace_img, table_html)

# Now, the table is cleaned.

# To make it standalone, add html body

full_html = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dungeons - Card Wars Kingdom</title>
</head>
<body>
{table_html}
</body>
</html>'''

# Write to dungeon.html
with open('dungeon.html', 'w', encoding='utf-8') as f:
    f.write(full_html)