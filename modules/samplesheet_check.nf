process SAMPLESHEET_CHECK {

    input:
    path samplesheet

    output:
    path '*.csv'       , emit: csv

    script: // This script is bundled with the pipeline, in nf-core/rnaseq/bin/
    """
    python /home/kai/cat_nextflow_pipeline/bin/check_samplesheet.py\\
        $samplesheet \\
        samplesheet.valid.csv
    """
}

