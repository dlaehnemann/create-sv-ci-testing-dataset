rule get_genome:
    output:
        "resources/genome.fasta",
    params:
        species="homo_sapiens",
        datatype="dna",
        build="GRCh38",
        release="110",
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
    resources:
        mem_mb=lambda wc, input: 25 * input.size_mb,
    wrapper:
        "v2.9.1/bio/bwa-mem2/index"


rule fix_target_bed:
    input:
        bed=config["capture_bed"],
    output:
        bed="resources/capture_regions.bed",
    log:
        "logs/capture_regions.bed",
    localrule: True
    conda:
        "../envs/sed.yaml"
    shell:
        "sed -e '1,2 d' -e 's/^chr//' {input.bed} > {output.bed} 2>{log}"
