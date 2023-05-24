process INVERSE_COLOUR { 

    publishDir "results_directory"

    input:
    tuple val(id), path(image_path)

    output: 
    tuple val(id), path("${id}_final.jpg"), emit: inverse

    script: 
    """
    #!/usr/bin/env python

    from PIL import Image
    import PIL.ImageOps    

    image = Image.open('${image_path}')
    inverted_image = PIL.ImageOps.invert(image)

    # Define the output file path
    inverted_image.save("${id}_final.jpg")
    """
}