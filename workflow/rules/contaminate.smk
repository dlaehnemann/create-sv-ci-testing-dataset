rule create_contaminated_tumor_sample:
    input:
        tumor=lambda wc: expand(
            "results/downsampled/{{tumor_sample}}.{{chr}}.{depth}x.bam",
            depth=(100 - float(wc.contamination)) * float(wc.total_depth) / 100,
        ),
        normal=lambda wc: expand(
            "results/downsampled/{{normal_sample}}.{{chr}}.{depth}x.bam",
            depth=float(wc.contamination) * float(wc.total_depth) / 100,
        ),
    output:
        "results/contaminated/{tumor_sample}.{chr}.{total_depth}x.{contamination}_percent_{normal_sample}_contamination.bam",
        idx="results/contaminated/{tumor_sample}.{chr}.{total_depth}x.{contamination}_percent_{normal_sample}_contamination.bam.bai",
    log:
        "logs/contaminated/{tumor_sample}.{chr}.{total_depth}x.{contamination}_percent_{normal_sample}_contamination.log",
    params:
        extra="-R {chr}",  # optional additional parameters as string
    threads: 4
    wrapper:
        "v3.0.4/bio/samtools/merge"
