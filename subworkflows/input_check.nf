//
// Check input samplesheet and get read channels
//

include { SAMPLESHEET_CHECK } from '../modules/samplesheet_check'

workflow INPUT_CHECK {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    SAMPLESHEET_CHECK ( samplesheet )
        .csv
        .splitCsv ( header:true, sep:',' )
        .map { create_path_channel(it) }
        .set { reads }

    emit:
    reads                                     // channel: [ val(id), path(reads) ]
}

// Function to get list of [ sample, path ]
def create_path_channel(LinkedHashMap row) {
    def array = []
    if (!file(row.path).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> path does not exist!\n${row.path}"
    }
    array = [ row.sample, file(row.path) ]

    return array
}