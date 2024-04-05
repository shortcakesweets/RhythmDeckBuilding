import os
from PIL import Image

def flip_horizontal(input_folder, output_folder):
    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # List all files in the input folder
    files = os.listdir(input_folder)
    
    # Process each file in the input folder
    for file in files:
        # Check if the file is a PNG image
        if file.endswith(".png"):
            # Get the full path of the input image
            input_path = os.path.join(input_folder, file)
            
            # Open the image
            img = Image.open(input_path)
            
            # Flip the image horizontally
            flipped_img = img.transpose(Image.FLIP_LEFT_RIGHT)
            
            # Construct the output path for the flipped image
            output_file_name = file.split('.')[0] + "_flipped.png"
            output_path = os.path.join(output_folder, output_file_name)
            
            # Save the flipped image
            flipped_img.save(output_path)
            
            print(f"Flipped {file} and saved as {output_file_name}")

# Example usage:
input_folder = "original"
output_folder = "flipped"

flip_horizontal(input_folder, output_folder)