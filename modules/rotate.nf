
process ROTATE {

    executor 'local'
    memory 32.GB

    input: 
    path(cat_image)

    output: 
    path("${cat_image.baseName}.jpg"), emit: rotated // Define the 'rotated_cat.jpg' file path

    script:
    """
    #!/usr/bin/env python
    from PIL import Image
  
    # Giving The Original image Directory 
    Original_Image = Image.open('${cat_image}')
  
    # Rotate Image By 180 Degree
    rotated_image = Original_Image.rotate(180)

    # Define the output file path
    output_path = "${cat_image.baseName}.jpg"
    
    saved_rotated_image = rotated_image.save(output_path)
    """

}
