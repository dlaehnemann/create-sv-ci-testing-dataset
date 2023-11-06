rule bwa_mem2_map_raw_trimmed:
    input:
        reads=expand(
            "results/trimmed/{accession}.{read}.fastq.gz",
            accession=lambda wc: config[wc.sample]["sra_accession"],
            read=["1","2"],
        ),
        # Index can be a list of (all) files created by bwa, or one of them
        idx=multiext(
            "resources/genome",
            ".fasta",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac"
        ),
    output:
        "results/mapped/{sample}.bam",
    log:
        "logs/bwa_mem2/{sample}.log",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sort="none",  # Can be 'none', 'samtools', or 'picard'.
        sort_order="coordinate",  # Can be 'coordinate' (default) or 'queryname'.
        sort_extra="",  # Extra args for samtools/picard sorts.
    threads: 8
    wrapper:
        "v2.9.1/bio/bwa-mem2/mem"