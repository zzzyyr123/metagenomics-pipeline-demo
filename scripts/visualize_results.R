#!/usr/bin/env Rscript

# 可视化宏基因组分析结果
# 用法: Rscript visualize_results.R <pathabundance_file>

# 获取命令行参数
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("请提供通路丰度文件路径")
}

input_file <- args[1]
output_dir <- "../results/downstream"

# 创建输出目录（如果不存在）
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# 加载包
packages <- c("tidyverse", "reshape2", "ggplot2", "pheatmap")
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "http://cran.us.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

# 读取数据
cat("读取通路丰度数据...\n")
data <- read.table(input_file, 
                   header = TRUE, 
                   row.names = 1, 
                   sep = "\t", 
                   comment.char = "#", 
                   check.names = FALSE)

# 过滤掉以 UN 开头或包含 unclassified 的行
rows_to_keep <- !grepl("^UN[A-Z]+|unclassified", rownames(data))
data_filtered <- data[rows_to_keep, , drop = FALSE]

# 调试信息
cat("原始数据行数:", nrow(data), "\n")
cat("过滤后行数:", nrow(data_filtered), "\n")
cat("过滤掉的行:\n")
print(rownames(data)[!rows_to_keep])

if (nrow(data_filtered) == 0) {
  cat("警告：过滤后没有数据。使用前20个通路继续运行...\n")
  data_filtered <- data[1:min(20, nrow(data)), , drop = FALSE]
}

# 1. 绘制Top20通路图
cat("生成Top20通路图...\n")
if (nrow(data_filtered) >= 20) {
  top20 <- data_filtered[order(data_filtered[,1], decreasing = TRUE)[1:20], , drop = FALSE]
} else {
  top20 <- data_filtered
}

# 如果只有一个样本，画水平条形图
if (ncol(top20) == 1) {
  pdf(paste0(output_dir, "/top20_pathways_barplot.pdf"), width = 12, height = 8)
  par(mar = c(5, 12, 4, 2))
  barplot(top20[,1], 
          names.arg = rownames(top20),
          horiz = TRUE,
          las = 1,
          cex.names = 0.6,
          main = "Top 20 Metabolic Pathways",
          xlab = "Abundance",
          col = "steelblue")
  dev.off()
  cat("生成了水平条形图（因为只有一个样本）\n")
} else {
  # 多个样本时画热图
  pdf(paste0(output_dir, "/top20_pathways_heatmap.pdf"), width = 10, height = 8)
  pheatmap(as.matrix(top20),
           main = "Top 20 Metabolic Pathways",
           fontsize_row = 8,
           fontsize_col = 10,
           cluster_cols = FALSE,
           color = colorRampPalette(c("navy", "white", "firebrick"))(100))
  dev.off()
  cat("生成了热图\n")
}
# 2. 绘制丰度分布箱线图
cat("生成丰度分布图...\n")
data_long <- data_filtered %>%
  as.data.frame() %>%
  rownames_to_column("pathway") %>%
  pivot_longer(-pathway, names_to = "sample", values_to = "abundance")

pdf(paste0(output_dir, "/abundance_distribution.pdf"), width = 8, height = 6)
ggplot(data_long, aes(x = sample, y = log10(abundance + 1))) +
  geom_boxplot(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Pathway Abundance Distribution",
       x = "Sample",
       y = "log10(Abundance + 1)")
dev.off()

# 3. 输出统计信息
cat("\n统计信息:\n")
cat("总通路数:", nrow(data_filtered), "\n")
cat("样本数:", ncol(data_filtered), "\n")
cat("平均每条样本的通路数:", mean(colSums(data_filtered > 0)), "\n")

# 保存统计信息
writeLines(c(
  paste("总通路数:", nrow(data_filtered)),
  paste("样本数:", ncol(data_filtered)),
  paste("平均每条样本的通路数:", mean(colSums(data_filtered > 0)))
), paste0(output_dir, "/statistics.txt"))

cat("可视化完成！结果保存在", output_dir, "\n")
