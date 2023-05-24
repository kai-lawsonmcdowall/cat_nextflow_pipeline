#!/usr/bin/env python

import os
import sys
import errno
import argparse


def parse_args(args=None):
    Description = "Reformat samplesheet file and check its contents."
    Epilog = "Example usage: python check_samplesheet.py <FILE_IN> <FILE_OUT>"

    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("FILE_IN", help="Input samplesheet file.")
    parser.add_argument("FILE_OUT", help="Output file.")

    return parser.parse_args(args)


def make_dir(path):
    """Used to create the directory for the cleaned, output csv file"""
    if len(path) > 0:
        try:
            os.makedirs(path)
        except OSError as exception:
            if exception.errno != errno.EEXIST:
                raise exception


def print_error(error, context="Line", context_str=""):
    """
    Prints the line that an error has occured and the context_str as returned by check_samplesheet.
    """
    error_str = "ERROR: Please check samplesheet -> {}".format(error)
    if context != "" and context_str != "":
        error_str = "ERROR: Please check samplesheet -> {}\n{}: '{}'".format(
            error, context.strip(), context_str.strip()
        )
    print(error_str)
    sys.exit(1)


def check_samplesheet(file_in, file_out):
    """
    This function checks that the samplesheet follows the following structure:
    sample, path
    sample_1,/path/to/sample1.jpg
    sample_2,/path/to/sample2.jpg
    """

    sample_mapping_dict = {}
    with open(file_in, "r", encoding="utf-8-sig") as fin:
        MIN_COLS = 2
        ## Check header
        HEADER = ["sample", "path"]
        header = [x.strip('"') for x in fin.readline().strip().split(",")]
        if header[: len(HEADER)] != HEADER:
            print(
                "ERROR: Please check samplesheet header -> {} != {}".format(
                    ",".join(header), ",".join(HEADER)
                )
            )
            sys.exit(1)

        ## Check sample entries
        for line in fin:
            sample_metadata = [x.strip().strip('"') for x in line.strip().split(",")]

            # Check valid number of columns per row
            if len(sample_metadata) < len(HEADER):
                print_error(
                    "Invalid number of columns (minimum = {})!".format(len(HEADER)),
                    "Line",
                    line,
                )
            num_cols = len([x for x in sample_metadata if x])
            if num_cols < MIN_COLS:
                print_error(
                    "Invalid number of populated columns (minimum = {})!".format(
                        MIN_COLS
                    ),
                    "Line",
                    line,
                )

            ## Check sample name entries
            sample, path = sample_metadata[: len(HEADER)]
            if sample.find(" ") != -1:
                print(
                    f"WARNING: Spaces have been replaced by underscores for sample: {sample}"
                )
                sample = sample.replace(" ", "_")
            if not sample:
                print_error("Sample entry has not been specified!", "Line", line)

            ## Check path file extension
            if not path.endswith(".jpg"):
                print_error(
                    "the image does not have the extension '.jpg'",
                    "Line",
                    line,
                )

            ## Create sample mapping dictionary = { sample: path }
            if sample not in sample_mapping_dict:
                sample_mapping_dict[sample] = path
            else:
                print_error(
                    f"Samplesheet contains duplicate samples! {sample}, line {line}"
                )

    ## Write validated samplesheet with appropriate columns
    if len(sample_mapping_dict) > 0:
        out_dir = os.path.dirname(file_out)
        make_dir(out_dir)
        with open(file_out, "w") as fout:
            fout.write(",".join(["sample", "path"]) + "\n")
            for sample in sorted(sample_mapping_dict.keys()):
                fout.write(f"{sample},{sample_mapping_dict[sample]}\n")
    else:
        print_error("No entries to process!", "Samplesheet: {}".format(file_in))


def main(args=None):
    args = parse_args(args)
    check_samplesheet(args.FILE_IN, args.FILE_OUT)


if __name__ == "__main__":
    sys.exit(main())
