#!/bin/bash
#SBATCH --job-name=metagenomics_demo
#SBATCH --output=logs/snakemake_%j.out
#SBATCH --error=logs/snakemake_%j.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=48G
#SBATCH --partition=normal

# 使用完整路径激活环境（不依赖 .bashrc）
source ~/.bashrc
conda activate metagenomics

export PERL5LIB=/usr/share/perl5:/usr/lib64/perl5:$PERL5LIB
# 验证环境是否激活成功
which python
which humann
which metaphlan

# 进入项目目录
cd /public/home/Immunoprofiling/zhaoyr/metagenomics_pipeline_demo || { echo "目录不存在"; exit 1; }

# 创建日志目录
mkdir -p logs

# 运行Snakemake
snakemake -s workflow/Snakefile2 --cores $SLURM_CPUS_PER_TASK --rerun-incomplete
