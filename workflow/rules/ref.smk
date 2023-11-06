rule get_genome:
    output:
        "resources/genome.fasta",
    params:
        species="homo_sapiens",
        datatype="dna",
        build="GRCh38",
        release="111",
    log:
        "logs/get_genome.log",
    cache: "omit-software"  # save space and time with between workflow caching (see docs)
    wrapper:
        "v2.9.1/bio/reference/ensembl-sequence"


rule bwa_mem2_index:
    input:
        "resources/{genome}.fasta",
    output:
        multiext(
            "resources/{genome}",
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    log:
        "logs/bwa-mem2_index/{genome}.log",
    wrapper:
        "v2.9.1/bio/bwa-mem2/index"