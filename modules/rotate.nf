
process ROTATE {


    executor 'local'
    memory 32.GB

    input: 
    tuple val(id), path(image_path)

    output: 
    tuple val(id), path("${id}.jpg"), emit: rotated // Define the 'rotated_cat.jpg' file path

    script:
    """
    #!/usr/bin/env python
    from PIL import Image
  
    # Giving The Original image Directory 
    Original_Image = Image.open('${image_path}')
  
    # Rotate Image By 180 Degree
    rotated_image = Original_Image.rotate(180)

    # Define the output file path
    output_path = "${id}.jpg"
    
    saved_rotated_image = rotated_image.save(output_path)
    """

}
