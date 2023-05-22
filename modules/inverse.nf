process INVERSE_COLOUR { 

    publishDir "results_directory"

    input:
    path(rotated)

    output: 
    path("${rotated.baseName}_final.jpg")

    script: 
    """
    #!/usr/bin/env python

    from PIL import Image
    import PIL.ImageOps    

    image = Image.open('${rotated}')
    inverted_image = PIL.ImageOps.invert(image)

    # Define the output file path
    output_path = "${rotated.baseName}_final.jpg"

    inverted_image.save(output_path)
    """
}