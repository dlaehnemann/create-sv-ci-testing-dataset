rule get_fastqs:
    output:
        # the wildcard name must be accession, pointing to an SRA number
        "raw/{accession}_1.fastq.gz",
        "raw/{accession}_2.fastq.gz",
    log:
        "logs/get_fastqs/{accession}.gz.log",
    params:
        extra="--skip-technical",
    threads: 6  # defaults to 6
    wrapper:
        "v2.9.1/bio/sra-tools/fasterq-dump"
