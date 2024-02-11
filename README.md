# ViralVariantCalling

## 🚧 Work on going, scripts still being written and added (11/02/2024) 🚧
 
## :dart: Aim
- Perform variant analysis of EBV viral sample genomes.

## 📜 Note
- Shell scripts (.sh) are designed to run on QMUL HPC.
- Scripts in this repository require the following software packages:
  - fastqc & multiqc
  - bowtie2
  - trimgalore
  - samtools
  - jupyter notebook
    - pandas, glob, matplotlib, numpy
- This project required alignment of samples to different versions of the EBV reference genome, therefore there are versions of scripts for the relevant genome.
  - ❗future iterations of this analysis will remove this redudnacy and have a function where reference genome can be specified rather than separate scripts. 

## :pencil: Scripts
1. Initial QC using `1-fastqc.sh`
2. Build relevant bowtie 2 indices using `2-bowtie-build-xxx.sh`
3. If required, build a consensus sequence of multiple sequence alignments using `2i-xxx-cons.sh`
4. Trim adapters and low quality bases from reads using `3-trimgalore.sh`
5. Align sequences to reference genome using `4-bowtie-xxx.sh`
6. Gather alignment QC metrics using `5-samtools-process.sh`
7. Visualise key QC metrics such as mapping rate using `6-alignmentQC.ipynb`
