rule cutadapt:
    input:
        ["raw/{accession}_1.fastq.gz", "raw/{accession}_2.fastq.gz"],
    output:
        fastq1="results/trimmed/{accession}.1.fastq.gz",
        fastq2="results/trimmed/{accession}.2.fastq.gz",
        qc="results/trimmed/{accession}.qc.txt",
    params:
        # https://cutadapt.readthedocs.io/en/stable/guide.html#adapter-types
        adapters=config["cutadapt"]["adapters"],
        # https://cutadapt.readthedocs.io/en/stable/guide.html#
        extra=config["cutadapt"]["extra"],
    log:
        "logs/cutadapt/{accession}.log",
    threads: 8  # set desired number of threads here
    wrapper:
        "v2.9.1/bio/cutadapt/pe"
