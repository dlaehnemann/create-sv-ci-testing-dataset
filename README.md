# Snakemake workflow: `create-sv-ci-testing-dataset`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/dlaehnemann/create-sv-ci-testing-dataset/workflows/Tests/badge.svg?branch=main)](https://github.com/dlaehnemann/create-sv-ci-testing-dataset/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for creating a structural variant testing dataset that is both small enough to run in standard continuous integration testing environments, and large enough to produce meaningful results.

This workflow is based on the data presented and analyzed here:

Talsania, K., Shen, Tw., Chen, X. *et al.* Structural variant analysis of a cancer reference cell line sample using multiple sequencing technologies. *Genome Biol* **23**, 255 (2022). https://doi.org/10.1186/s13059-022-02816-6

The full data can be found here:

https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA489865&o=acc_s%3Aa

We use Illumina data from the breast cancer cell line (`HCC1395`) and the corresponding normal (B lymphoblast) cell line (`HCC1395BL`), to generate reduced and downsampled testing samples:

1. A regular normal sample.
2. A mixture of the cancer and normal cell lines at known fraction(s), to be able test for the resulting expected purity.

To reduce the dataset, we:
1. Focus on chromosome 22 or some other chromosome with meaningful structural variants.
2. Downsample that region to a still usable coverage (~30X?).

The high-confidence consensus structural variant call set from the above paper is in its supplementary table S4:
https://static-content.springer.com/esm/art%3A10.1186%2Fs13059-022-02816-6/MediaObjects/13059_2022_2816_MOESM4_ESM.xlsx


## Usage

The usage of this workflow is described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=dlaehnemann%2Fcreate-sv-ci-testing-dataset).

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and its DOI (see above).