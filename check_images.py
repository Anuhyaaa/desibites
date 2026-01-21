from PIL import Image
import os

images = [
    "images/chole-bhature.jpg",
    "images/poha.jpg",
    "images/masala-dosa.jpg"
]

for path in images:
    if os.path.exists(path):
        img = Image.open(path)
        size_kb = os.path.getsize(path) / 1024
        print(f"{os.path.basename(path)}: {img.size[0]}x{img.size[1]} - {size_kb:.1f}KB")
