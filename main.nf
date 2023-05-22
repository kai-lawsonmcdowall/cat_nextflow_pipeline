// enable DSL2
nextflow.enable.dsl=2


// Import single processes
include { ROTATE                    } from './modules/rotate.nf'
include { INVERSE_COLOUR            } from './modules/inverse.nf'


params.cat_image = "${baseDir}/images/*.jpg"

workflow {
    def rotate_channel = Channel.fromPath(params.cat_image)
    
    println("Printing Rotation Channel Contents")
    rotate_channel.view()
    rotated_channel = ROTATE(rotate_channel)

    println("viewing outputs of the rotated process")
    rotated_channel.view()

    inverse_channel = INVERSE_COLOUR(rotated_channel.rotated)
    }