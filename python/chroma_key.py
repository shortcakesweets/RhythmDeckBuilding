from PIL import Image

def remove_black_and_save(input_path, output_path, tolerance=30):
    try:
        # Open the PNG image
        image = Image.open(input_path)

        # Convert the image to RGBA mode (if not already in RGBA)
        image = image.convert("RGBA")

        # Get the image data as a list of pixels
        data = list(image.getdata())

        # Define a function to check if a pixel is similar to black
        def is_black(pixel):
            return all(value <= tolerance for value in pixel[:3])

        # Replace pixels similar to black with a fully transparent pixel
        new_data = [(0, 0, 0, 0) if is_black(pixel) else pixel for pixel in data]

        # Create a new image with the modified pixel data
        new_image = Image.new("RGBA", image.size)
        new_image.putdata(new_data)

        # Save the result as a new PNG file
        new_image.save(output_path, format="PNG")

        print(f"Black color removal successful! Result saved at {output_path}")

    except Exception as e:
        print(f"Error: {e}")

# Replace 'input.png' with the path to your PNG file
input_path = 'input.png'

# Replace 'output_no_black.png' with the desired output path for the modified PNG file
output_path = 'output_no_black.png'

# Specify the tolerance for considering a pixel as black (adjust as needed)
tolerance = 30

remove_black_and_save(input_path, output_path, tolerance)
