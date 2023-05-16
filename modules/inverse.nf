process INVERSE_COLOUR { 

    publishDir "results_directory"

    input:
    path(rotated)

    output: 
    path('inverse_cat.jpg')

    script: 
    """
    #!/usr/bin/env python

    from PIL import Image
    import PIL.ImageOps    

    image = Image.open('${rotated}')
    inverted_image = PIL.ImageOps.invert(image)

    # Define the output file path
    output_path = "${'inverse_cat.jpg'}"

    inverted_image.save(output_path)
    """
}