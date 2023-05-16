// enable DSL2
nextflow.enable.dsl=2


// Import single processes
include { ROTATE                    } from './modules/rotate.nf'
include { INVERSE_COLOUR            } from './modules/inverse.nf'


params.cat_image = '/home/kai/nextflow_image_pipeline/images/*.jpg'

workflow {
    def rotate_channel = Channel.fromPath(params.cat_image)
    rotated_channel = ROTATE(rotate_channel)
    inverse_channel = INVERSE_COLOUR(rotated_channel.rotated)
    }
