import os
import sys

def install_pillow():
    import subprocess
    print("Installing Pillow...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
        print("Pillow installed successfully.")
    except Exception as e:
        print(f"Failed to install Pillow: {e}")
        return False
    return True

try:
    from PIL import Image
except ImportError:
    print("Pillow not found. Attempting to install...")
    if not install_pillow():
        sys.exit(1)
    from PIL import Image

def compress_images(directory):
    # Target settings
    MAX_WIDTH = 800
    QUALITY = 80
    
    print(f"Scanning {directory}...")
    
    for filename in os.listdir(directory):
        if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
            filepath = os.path.join(directory, filename)
            
            try:
                with Image.open(filepath) as img:
                    # Get current size
                    original_size = os.path.getsize(filepath)
                    
                    # Check if resize needed
                    if img.width > MAX_WIDTH:
                        # Calculate new height
                        ratio = MAX_WIDTH / float(img.width)
                        new_height = int((float(img.height) * ratio))
                        img = img.resize((MAX_WIDTH, new_height), Image.Resampling.LANCZOS)
                        
                    # Save compressed
                    img.save(filepath, optimize=True, quality=QUALITY)
                    
                    new_size = os.path.getsize(filepath)
                    saved = (original_size - new_size) / 1024
                    print(f"Compressed {filename}: {original_size/1024:.1f}KB -> {new_size/1024:.1f}KB (Saved {saved:.1f}KB)")
                    
            except Exception as e:
                print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    img_dir = r"c:\Users\91768\OneDrive\Documents\webPage\images"
    compress_images(img_dir)
