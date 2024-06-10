from tkinter import *
from tkinter import filedialog
from PIL import Image, ImageTk
from ultralytics import YOLO

# Function to perform prediction using YOLO model
def predict_image():
    # Load the YOLO model
    model = YOLO("F:\\PBL5\\best.pt")
    # Get the path of the selected image
    image_path = filedialog.askopenfilename()
    
    # Load and resize the image
    original_image = Image.open(image_path)
    resized_image = original_image.resize((616, 416))
    
    # Perform prediction on the resized image
    results = model.predict(show=True, source=resized_image)
    
    # Convert the annotated image to a PIL Image
    annotated_pil_image = Image.fromarray(results[0].image)
    
    # Convert the PIL Image to a Tkinter PhotoImage
    tk_image = ImageTk.PhotoImage(image=annotated_pil_image)
    
    # Create a new Toplevel window for displaying the image
    display_window = Toplevel(root)
    display_window.title("Annotated Image")
    
    # Create a Label to display the image
    image_label = Label(display_window, image=tk_image)
    image_label.pack()
    
    # Keep a reference to the image to prevent it from being garbage collected
    image_label.image = tk_image

# Initialize Tkinter
root = Tk()
root.title("YOLO Image Prediction")

# Create a button to select image and perform prediction
select_image_button = Button(root, text="Select Image", command=predict_image)
select_image_button.grid(row=0, column=0, padx=20, pady=20)

# Create a label for displaying the prediction result
result_label = Label(root, text="Prediction Result:")
result_label.grid(row=1, column=0, padx=20, pady=20)

# Run the Tkinter main loop
root.mainloop()
