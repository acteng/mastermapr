
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mastermapr

<!-- badges: start -->

[![R-CMD-check](https://github.com/acteng/mastermapr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/acteng/mastermapr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of mastermapr is to make it easy to get your OS data imported
into open source software for reproducible data science and analysis
(#rspatial).

## Installation

You can install the development version of mastermapr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("acteng/mastermapr")
```

## Example

This is a basic example which shows you can read in road data for GB
with the package:

``` r
library(mastermapr)
# This takes around 30 s on decent laptop as of 2023
# so should be around 10 min for full dataset:
system.time({
  mm_data = mm_read(directory, pattern = "RoadLink", n_files = 8) # 5% of GB files
})
# saveRDS(mm_data, "mm_data_RoadLink.Rds")
```
