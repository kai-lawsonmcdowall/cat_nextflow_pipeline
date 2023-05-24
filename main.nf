// enable DSL2
nextflow.enable.dsl=2

// Import Subworkflows
include { INPUT_CHECK } from './subworkflows/input_check'
// Import single processes
include { ROTATE                    } from './modules/rotate.nf'
include { INVERSE_COLOUR            } from './modules/inverse.nf'


// params.cat_image = "${baseDir}/images/*.jpg"

if (params.input) {
    ch_input = file(params.input) } else { exit 1, 'Input samplesheet not specified with --input or in a config file!'
}

workflow {

    INPUT_CHECK (ch_input)

    ROTATE(INPUT_CHECK.out.reads)

    println("Printing Rotation Channel Contents")
    ROTATE.out.rotated.view()

    INVERSE_COLOUR(ROTATE.out.rotated)


    }