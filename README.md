# Metagenomics Pipeline Demo

[![Snakemake](https://img.shields.io/badge/snakemake-≥7.0-brightgreen.svg)](https://snakemake.github.io)
[![HUMAnN](https://img.shields.io/badge/HUMAnN-3.8-blue)](https://huttenhower.sph.harvard.edu/humann/)
[![R](https://img.shields.io/badge/R-4.2-blue)](https://www.r-project.org/)

## 📌 Overview
This repository provides a **complete, end-to-end metagenomic functional profiling pipeline** using [HUMAnN 3](https://huttenhower.sph.harvard.edu/humann/). It processes raw FASTQ data to generate **metabolic pathway abundance tables**, with full support for Slurm HPC clusters.

The pipeline has been successfully tested on real demo data, proving its robustness in production HPC environments.

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/你的用户名/metagenomics-pipeline-demo.git
cd metagenomics-pipeline-demo
```

### 2. Set up the environment
```bash
# Create and activate Conda environment
conda env create -f environment.yml
conda activate metagenomics
```

### 3. Run the pipeline

#### Option A: Submit to Slurm cluster (recommended)
```bash
sbatch submit_demo.sbatch
```

#### Option B: Run locally
```bash
snakemake -s workflow/Snakefile --cores 2
```

## 📊 Pipeline Structure
```
Raw FASTQ (data/raw/demo_1.fastq)
    ↓
[fastp] → QC reports (results/fastp/)
    ↓
[HUMAnN] → **Core output**: pathway abundance table (results/humann/demo_pathabundance.tsv)
    ↓
[Downstream] → Top pathways, alpha diversity, visualizations
```

## 🔬 Key Results (Successfully Generated!)

### 1. Metabolic Pathway Abundance Table (HUMAnN Core Output)

Here are the top pathways from the actual demo run:

```
# Pathway    Abundance
DTDPRHAMSYN-PWY: dTDP-β-L-rhamnose biosynthesis    110.74
PWY-6700: queuosine biosynthesis I (de novo)        92.16
PWY-6124: inosine-5‘-phosphate biosynthesis II      90.46
VALSYN-PWY: L-valine biosynthesis                   90.12
PWY-6609: adenine and adenosine salvage III         87.48
PWY-1042: glycolysis IV                             85.12
PWY-6703: preQ0 biosynthesis                         82.89
PWY-5695: inosine 5’-phosphate degradation          82.02
```

> 📁 Full table available at [`assets/demo_pathabundance.tsv`](assets/demo_pathabundance.tsv)

### 2. Visualization

#### Top 20 Metabolic Pathways (Bar Plot)
![Top 20 Pathways](assets/images/top20_pathways_barplot.pdf)

*This plot was generated directly from the pipeline output using R.*

### 3. Pipeline Execution Log

The pipeline was successfully executed on a Slurm cluster with the following configuration:
- **Job ID**: 3534694
- **Runtime**: ~20 minutes
- **Memory**: 48GB
- **CPUs**: 2

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| [Snakemake](https://snakemake.github.io/) | Workflow automation |
| [fastp](https://github.com/OpenGene/fastp) | Quality control |
| [HUMAnN 3](https://huttenhower.sph.harvard.edu/humann/) | Functional profiling (pathway abundance) |
| [R](https://www.r-project.org/) | Visualization (ggplot2, pheatmap) |
| [Slurm](https://slurm.schedmd.com/) | HPC job scheduling |

## 📁 Repository Structure

```
.
├── workflow/
│   └── Snakefile           # Main pipeline definition
├── scripts/
│   └── visualize_results.R # R visualization script
├── assets/
│   ├── demo_pathabundance.tsv  # Core result file
│   └── images/                  # Generated figures
├── submit_demo.sbatch       # Slurm submission script
├── environment.yml          # Conda environment specification
└── README.md                # This file
```

## 🔄 Future Extensions
- [ ] Multi-sample batch processing
- [ ] Differential abundance analysis (MaAsLin2)
- [ ] Containerization (Docker/Singularity)
- [ ] Integration with metabolomics data

## 📬 Contact
**Yiran Zhao**  
Human Phenome Institute, Fudan University  
📧 zhaoyr21@m.fudan.edu.cn ; zhaoyr2023@outlook.com 
🌐 [Personal Website](https://zzzyyr123.github.io/my_website_cv/)

---

*Last updated: 2026-03-05*
*Status: ✅ Pipeline successfully validated on demo data*
