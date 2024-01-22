import pandas as pd
from os import path
import sys
sys.stderr = open(snakemake.log[0], "w")

with open(snakemake.output.samples, "w") as s_out, open(snakemake.output.units, "w") as u_out:
    s_out.write(
        "\t".join([
            "sample_name",
            "group",
            "alias",
            "expected_contamination",
            "depth",
        ])
    )
    u_out.write(
        "\t".join([
            "sample_name",
            "unit_name",
        ])
    )
    for t in snakemake.input.tumor_samples:
        sample_name = path.splitext(path.basename(t))[0]
        [tumor_sample, chrom, depth_string, contam_string, _] = path.basename(t).split(".")
        depth = depth_string.rstrip("x")
        [ contamination, _, normal_sample, _ ] = contam_string.split("_")
        normal_name = ".".join([normal_sample, chrom, depth_string])
        s_out.write(
            "\t".join([
                sample_name,
                sample_name,
                "tumor",
                contamination,
                depth,
            ])
        )
        u_out.write(
            "\t".join([
                sample_name,
                "u1",
            ])
        )
        s_out.write(
            "\t".join([
                normal_name,
                sample_name,
                "normal",
                "",
                depth,
            ])
        )
        u_out.write(
            "\t".join([
                normal_name,
                "u1",
            ])
        )