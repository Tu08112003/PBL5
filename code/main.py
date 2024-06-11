from PIL import Image
from ultralytics import YOLO

# Load the model
model = YOLO("C:/Users/ACER/Documents/PBL5/best.pt")

# Load and resize the image
image_path = "C:/Users/ACER/Documents/PBL/Dataset/train/table/table.12.jpg"
original_image = Image.open(image_path)
resized_image = original_image.resize((416, 416))  # Resize to YOLO input size

# Perform prediction on the resized image
results = model.predict(show=True, source=resized_image)

