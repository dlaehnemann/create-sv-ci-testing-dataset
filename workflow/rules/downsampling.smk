rule mosdepth_bed:
    input:
        bam="results/mapped/{sample}.full_genome.sorted.bam",
        bai="results/mapped/{sample}.full_genome.sorted.bam.bai",
        bed="resources/capture_regions.bed",
    output:
        "results/mosdepth/{sample}.{chr}.mosdepth.global.dist.txt",
        "results/mosdepth/{sample}.{chr}.mosdepth.region.dist.txt",
        "results/mosdepth/{sample}.{chr}.regions.bed.gz",
        summary="results/mosdepth/{sample}.{chr}.mosdepth.summary.txt",  # this named output is required for prefix parsing
    log:
        "logs/mosdepth/{sample}.{chr}.log",
    params:
        extra="--no-per-base --chrom {chr}" if config.get("chromosome_to_extract") else "--no-per-base",  # optional
    # additional decompression threads through `--threads`
    threads: 4  # This value - 1 will be sent to `--threads`
    wrapper:
        "v2.9.1/bio/mosdepth"


rule samtools_view_extract_chr:
    input:
        bam="results/mapped/{sample}.full_genome.sorted.bam",
        bai="results/mapped/{sample}.full_genome.sorted.bam.bai",
    output:
        bam="results/extract_chr/{sample}.{chr}.sorted.bam",
        idx="results/extract_chr/{sample}.{chr}.sorted.bam.bai",
    log:
        "logs/extract_chr/{sample}.{chr}.log",
    params:
        extra="",  # optional params string
        region="{chr}",  # optional region string
    threads: 2
    wrapper:
        "v2.9.1/bio/samtools/view"


def get_subsampling_ratio(wc, input):
    coverage_results = pd.read_csv(input.summary, delimiter="\t")
    region = f"{wc.chr}_region"
    region_coverage = float(
        coverage_results.loc[coverage_results["chrom"] == region, "mean"].squeeze()
    )
    ratio = float(wc.depth) / region_coverage
    return ratio


rule samtools_view_downsample:
    input:
        bam="results/extract_chr/{sample}.{chr}.sorted.bam",
        idx="results/extract_chr/{sample}.{chr}.sorted.bam.bai",
        summary="results/mosdepth/{sample}.{chr}.mosdepth.summary.txt",
    output:
        bam="results/downsampled/{sample}.{chr}.{depth}x.bam",
        idx="results/downsampled/{sample}.{chr}.{depth}x.bam.bai",
    log:
        "logs/downsampled/{sample}.{chr}.{depth}x.log",
    params:
        extra=lambda wc, input: f"--subsample {get_subsampling_ratio(wc, input)}",
        region="",  # optional region string
    threads: 2
    wrapper:
        "v2.9.1/bio/samtools/view"
