def get_sample_type(wildcards):
    if config["pure_tumor_sample"]["sample_name"] == wildcards.sample:
        return "pure_tumor_sample"
    elif config["pure_normal_sample"]["sample_name"] == wildcards.sample:
        return "pure_normal_sample"


def get_reads_for_mapping(wildcards):
    accession = config[get_sample_type(wildcards)].get("sra_accession")
    return [
        f"results/trimmed/{accession}.1.fastq.gz",
        f"results/trimmed/{accession}.2.fastq.gz",
    ]


rule bwa_mem2_map_raw_trimmed:
    input:
        reads=get_reads_for_mapping,
        # Index can be a list of (all) files created by bwa, or one of them
        idx=multiext(
            genome,
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    output:
        temp("results/mapped/{sample}.full_genome.bam"),
    log:
        "logs/bwa_mem2/{sample}.log",
    params:
        extra=lambda wc: f"-R '@RG\tID:{wc.sample}\tSM:{wc.sample}\tPL:{config[get_sample_type(wc)]['platform']}'",
        sort="none",  # Can be 'none', 'samtools', or 'picard'.
        sort_order="coordinate",  # Can be 'coordinate' (default) or 'queryname'.
        sort_extra="",  # Extra args for samtools/picard sorts.
    resources:
        mem_mb=lambda wc, input: input.size_mb,
    threads: 8
    wrapper:
        "v2.9.1/bio/bwa-mem2/mem"


rule samtools_sort_mapped:
    input:
        "results/mapped/{sample}.full_genome.bam",
    output:
        "results/mapped/{sample}.full_genome.sorted.bam",
    log:
        "logs/samtools_sort/{sample}.full_genome.sorted.log",
    params:
        extra="-m 4G",
    resources:
        mem_mb=33000,
    threads: 8
    wrapper:
        "v3.0.3/bio/samtools/sort"


rule samtools_index_mapped:
    input:
        "results/mapped/{sample}.full_genome.sorted.bam",
    output:
        "results/mapped/{sample}.full_genome.sorted.bam.bai",
    log:
        "logs/samtools_index_mapped/{sample}.full_genome.log",
    params:
        extra="",  # optional params string
    threads: 4  # This value - 1 will be sent to -@
    wrapper:
        "v2.9.1/bio/samtools/index"
