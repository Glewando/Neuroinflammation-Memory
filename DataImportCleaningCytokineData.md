Neuroinflammation effect on context discrimination memory: Data Import and Cleaning of qRT-PCR Data (cytokines, CXCL10 and BDNF)
================
Gail Lewandowski
April 3, 2017

Document Introduction
---------------------

In this document the raw qRT-PCR data for experiments 14x02 and 14x04 are imported. The imported data will be converted (if needed) to a tidy data form. The data will be compiled such that there is one dataset.
Notably, for each dataset observation is synonymous with row and variable is synonymous with column. Most frequently, variable will be used instead of column.

qRT-PCR overview
----------------

Recently, the Guzowski lab demonstrated that systemic administration of the bacterial endotoxin lipopolysaccharide (LPS) elevates mRNA expression of the pro-inflammatory cytokines IL-1*β*, TNF-*α*, and IL-6 in the rat brain (Czerniawski & Guzowski, 2014; Czerniawski et al., 2015). In this experiment they used quantitative real-time polymerase chain reaction (qRT-PCR) to measure the transcript expression in the dorsal hippocampus (dHPC) of :

-   IL-1*β*, TNF-*α*, and IL-6; pro-inflammatory cytokines

-   CXCL10 chemokine; a C-X-C motif chemokine 10 also known as Interferon gamma-induced protein 10

-   BDNF (brain-derived neurotrophic factor); a nerve growth factor

Because microglia are a source of cytokine and chemokine in the brain, it is of particular interest to examine the expression of these gene transcripts in response to LPS ± minocycline.

Load R packages required for data import and cleaning
-----------------------------------------------------

``` r
suppressMessages({
    library(rmarkdown)  ## render markdown docs (output)
    library(knitr)  ## knit markdown docs (output)
    library(readxl) ## read MS Excel worksheets into data tables
    library(pander)  ## generate tables in output
    library(tidyverse)  ## data wrangling: dplyr, tidyr
})
```

Data Import
-----------

The cytokine/chemokine/BDNF data for 14x02 and 14x04 are contained in a worksheets within two Microsoft Excel workbooks. In this step the data are imported from the Excel workbook into data tables.

``` r
## path to 14x02 Excel workbook with experiment data (base R)
path_14x02 <- file.path("neuroinflam_CDC_raw_data",
    "14x02_raw_cytokine_data.xlsx")

## path to 14x04 Excel workbook with experiment data
path_14x04 <- file.path("neuroinflam_CDC_raw_data",
    "14x04_raw_cytokine_data.xlsx")
```

The worksheet containing the 14x02 qRT-PCR data in the Microsoft workbook is:

``` r
## use the function excel_sheets() from the readxl package

## list the sheets in the 14x02 Excel workbook
excel_sheets(path_14x02)
```

    ## [1] "Sheet1"

The worksheet containing the 14x02 qRT-PCR data in the Microsoft workbook is:

``` r
## list the sheets in the 14x04 Excel workbook
excel_sheets(path_14x04)
```

    ## [1] "DH cytokines"

### Import 14x02 qRT-PCR data

``` r
## use the read_excel() function from the readxl package

## import 14x02 qRT-PCR data
pcr_14x02 <- read_excel(path = path_14x02,
                              sheet = "Sheet1",
                              na = "")
```

### Import 14x04 qRT-PCR data

``` r
## use the read_excel() function from the readxl package

## import 14x04 qRT-PCR data
pcr_14x04 <- read_excel(path = path_14x04,
                              sheet = "DH cytokines",
                              na = "")
```

Initial qRT-PCR Data Inspection:
--------------------------------

Here we make an initial inspection of the imported qRT-PCR datasets and identify issues to resolve in order to generate the corresponding tidy datasets.

### 14x02 qRT-PCR Data Inspection

#### Overview of the `pcr_14x02` data:

``` r
## overview of pcr_14x02
glimpse(pcr_14x02)
```

    ## Observations: 33
    ## Variables: 28
    ## $ BASELINE             <chr> NA, NA, NA, NA, "SAL-SAL", NA, NA, NA, NA...
    ## $                      <chr> "14x02_16", "14x02_17", "14x02_19", NA, N...
    ## $ mean CT Actin        <dbl> 15.92, 15.88, 16.63, NA, NA, 15.95, 17.58...
    ## $ mean CT IL-1B        <dbl> 28.64, 29.02, 29.45, NA, NA, 28.95, 30.31...
    ## $ <U+2206>CT IL-1      <dbl> 12.72000, 13.14000, 12.82000, 12.89333, N...
    ## $ <U+2206><U+2206>CT   <dbl> -0.17333333, 0.24666667, -0.07333333, NA,...
    ## $ Fold increase IL-1   <dbl> 1.1276609, 0.8428415, 1.0521448, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.007549106667...
    ## $ mean CT IL-6         <dbl> 33.52, 29.75, 31.01, NA, NA, 30.13, 31.30...
    ## $ <U+2206>CT IL-6      <dbl> 17.60000, 13.87000, 14.38000, 15.28333, N...
    ## $ <U+2206><U+2206>CT   <dbl> 2.3166667, -1.4133333, -0.9033333, NA, NA...
    ## $ Fold increase IL-6   <dbl> 0.2007307, 2.6635186, 1.8703825, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.578210591670...
    ## $ mean CT TNF          <dbl> 27.74, 28.87, 29.18, NA, NA, 29.85, 31.67...
    ## $ <U+2206>CT TNF       <dbl> 11.82000, 12.99000, 12.55000, 12.45333, N...
    ## $ <U+2206><U+2206>CT   <dbl> -0.63333333, 0.53666667, 0.09666667, NA, ...
    ## $ Fold increase TNF    <dbl> 1.5511448, 0.6893618, 0.9351912, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.058565948058...
    ## $ mean CT BDNF         <dbl> 24.70, 24.52, 27.46, NA, NA, 26.41, 27.09...
    ## $ <U+2206>CT BDNF      <dbl> 8.780000, 8.640000, 10.830000, 9.416667, ...
    ## $ <U+2206><U+2206>CT   <dbl> -0.63666667, -0.77666667, 1.41333333, NA,...
    ## $ Fold increase BDNF   <dbl> 1.55473281, 1.71316804, 0.37544323, NA, N...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.214448024852...
    ## $ mean CT CXCL10       <dbl> 30.68, 30.69, 32.59, NA, NA, 31.11, 32.60...
    ## $ <U+2206>CT CXCL10    <dbl> 14.76000, 14.81000, 15.96000, 15.17667, N...
    ## $ <U+2206><U+2206>CT   <dbl> -0.41666667, -0.36666667, 0.78333333, NA,...
    ## $ Fold increase CXCL10 <dbl> 1.3348399, 1.2893703, 0.5810228, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.068410985362...

From this view of the 14x02 qRT-PCR data we see that:

-   There are 33 rows and 28 variables

-   The variables containing the raw qRT-PCR data are the 6 variables beginning with "mean CT"

-   The second column contains the rat identifiers, but is missing a variable name

-   All variables other than the 6 identified above contain calculated variables

#### Inspection of 14x02 qRT-PCR data for missing values:

Are there rows in the 14x02 qRT-PCR dataset that do not have **any** raw data? If so, how many rows? To answer this question we look for rows in which the value for *all* the variables containing the raw qRT-PCR data are *NA* (missing).

First, we can look at a vector of the number of missing raw data values for each observation.

``` r
rowSums(is.na(pcr_14x02[,c(3:4,9,14,19,24)]))
```

    ##  [1] 0 0 0 6 6 0 0 0 0 6 6 0 0 0 0 0 0 6 6 0 0 0 0 0 6 6 0 0 0 0 0 0 6

We can see that there are 9 rows without data. These observations will be removed during the Data Cleaning step.

### 14x04 qRT-PCR Data Inspection

#### Overview of the `pcr_14x04` data:

``` r
## overview of pcr_14x04
glimpse(pcr_14x04)
```

    ## Observations: 32
    ## Variables: 27
    ## $ BASELINE             <chr> "14x04_07", "14x04_17", "14x04_09", NA, "...
    ## $ mean CT Actin        <dbl> 17.28, 16.84, 16.97, NA, NA, 18.76, 17.28...
    ## $ mean CT IL-1B        <dbl> 28.52, 27.52, 29.28, NA, NA, 29.39, 27.91...
    ## $ <U+2206>CT IL-1      <dbl> 11.24, 10.68, 12.31, 11.41, NA, 10.63, 10...
    ## $ <U+2206><U+2206>CT   <dbl> -0.17, -0.73, 0.90, NA, NA, -0.78, -0.78,...
    ## $ Fold increase IL-1   <dbl> 1.1250585, 1.6586391, 0.5358867, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.106528102528...
    ## $ mean CT IL-6         <dbl> 32.92, 31.27, 31.56, NA, NA, 32.96, 31.76...
    ## $ <U+2206>CT IL-6      <dbl> 15.64000, 14.43000, 14.59000, 14.88667, N...
    ## $ <U+2206><U+2206>CT   <dbl> 0.7533333, -0.4566667, -0.2966667, NA, NA...
    ## $ Fold increase IL-6   <dbl> 0.5932313, 1.3723673, 1.2283031, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.064633925755...
    ## $ mean CT TNF          <dbl> 29.14, 28.67, 29.39, NA, NA, 30.91, 29.32...
    ## $ <U+2206>CT TNF       <dbl> 11.86000, 11.83000, 12.42000, 12.03667, N...
    ## $ <U+2206><U+2206>CT   <dbl> -0.176666667, -0.206666667, 0.383333333, ...
    ## $ Fold increase TNF    <dbl> 1.1302694, 1.1540188, 0.7666642, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.016984104457...
    ## $ mean CT BDNF         <dbl> 33.78, 32.09, 31.35, NA, NA, 35.88, 32.48...
    ## $ <U+2206>CT BDNF      <dbl> 16.50000, 15.25000, 14.38000, 15.37667, N...
    ## $ <U+2206><U+2206>CT   <dbl> 1.12333333, -0.12666667, -0.99666667, NA,...
    ## $ Fold increase BDNF   <dbl> 0.4590320, 1.0917683, 1.9953844, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.182061542535...
    ## $ mean CT CXCL10       <dbl> 31.74, 31.47, 31.40, NA, NA, 33.41, 30.38...
    ## $ <U+2206>CT CXCL10    <dbl> 14.46000, 14.63000, 14.43000, 14.50667, N...
    ## $ <U+2206><U+2206>CT   <dbl> -0.04666667, 0.12333333, -0.07666667, NA,...
    ## $ Fold increase CXCL10 <dbl> 1.0328757, 0.9180640, 1.0545786, NA, NA, ...
    ## $                      <chr> NA, NA, "Baseline Mean:", "1.001839454876...

From this view of the 14x04 qRT-PCR data we see that the data is not in a tidy format. Specifics of the dataset include:

-   There are 32 rows and 27 variables

-   The variables containing the raw qRT-PCR data are the 6 variables beginning with "mean CT"

-   The first column (BASELINE) contains rat identifiers and group assignments.

-   All variables other than the 6 identified above contain calculated variables

#### Inspection of 14x04 qRT-PCR data for missing values:

Similar to the 14x02 qRT-PCR, the 14x04 qRT-PCR data can be inspected for missing values in the 6 variables containing the raw qRT-PCR data, by looking at a vector of the number of missing raw data values for each observation.

``` r
rowSums(is.na(pcr_14x04[,c(2:3,8,13,18,23)]))
```

    ##  [1] 0 0 0 6 6 0 0 0 0 0 6 6 0 0 0 0 0 6 6 0 0 0 0 0 6 6 0 0 0 0 0 0

We can see that there are 8 rows without data. These observations will be removed during the Data Cleaning step.

qRT-PCR Data Cleaning
---------------------

In this step the identified issues in the 14x02 and 14x04 qRT-PCR data are addressed.

### Select variables containing raw qRT-PCR data

The dataset contains variables that contain values calculated from the raw data, rather than the raw data itself. These variables will be removed and later re-calculated during the Data Transformation step in order to maintain transparent and reproducible data analysis.

``` r
## use the select() function of dplyr (tidyverse)

## select 14x02 vars
pcr_14x02 <- pcr_14x02[, c(2:4,9,14,19,24)] 

## select 14x04 vars
pcr_14x04 <- pcr_14x04[, c(1:3,8,13,18,23)]
```

### Rename pcr\_14x02 variables

``` r
## create a vector with new variable names
vars <- c("rat", "ave_act_ct", "ave_IL1_ct",
          "ave_IL6_ct", "ave_TNF_ct", 
          "ave_BDNF_ct", "ave_CXCL10_ct")

## replace pcr_14x02 variable names with new names
names(pcr_14x02) <- vars

## replace pcr_14x04 variable names with new names
names(pcr_14x04) <- vars
```

We can inspect the resulting datasets:

**14x02 qRT-PCR data: **

``` r
glimpse(pcr_14x02)
```

    ## Observations: 33
    ## Variables: 7
    ## $ rat           <chr> "14x02_16", "14x02_17", "14x02_19", NA, NA, "14x...
    ## $ ave_act_ct    <dbl> 15.92, 15.88, 16.63, NA, NA, 15.95, 17.58, 16.24...
    ## $ ave_IL1_ct    <dbl> 28.64, 29.02, 29.45, NA, NA, 28.95, 30.31, 28.88...
    ## $ ave_IL6_ct    <dbl> 33.52, 29.75, 31.01, NA, NA, 30.13, 31.30, 30.47...
    ## $ ave_TNF_ct    <dbl> 27.74, 28.87, 29.18, NA, NA, 29.85, 31.67, 29.23...
    ## $ ave_BDNF_ct   <dbl> 24.70, 24.52, 27.46, NA, NA, 26.41, 27.09, 26.13...
    ## $ ave_CXCL10_ct <dbl> 30.68, 30.69, 32.59, NA, NA, 31.11, 32.60, 28.92...

**14x04 qRT-PCR data: **

``` r
glimpse(pcr_14x04)
```

    ## Observations: 32
    ## Variables: 7
    ## $ rat           <chr> "14x04_07", "14x04_17", "14x04_09", NA, "SAL-SAL...
    ## $ ave_act_ct    <dbl> 17.28, 16.84, 16.97, NA, NA, 18.76, 17.28, 16.80...
    ## $ ave_IL1_ct    <dbl> 28.52, 27.52, 29.28, NA, NA, 29.39, 27.91, 27.93...
    ## $ ave_IL6_ct    <dbl> 32.92, 31.27, 31.56, NA, NA, 32.96, 31.76, 31.46...
    ## $ ave_TNF_ct    <dbl> 29.14, 28.67, 29.39, NA, NA, 30.91, 29.32, 29.24...
    ## $ ave_BDNF_ct   <dbl> 33.78, 32.09, 31.35, NA, NA, 35.88, 32.48, 32.72...
    ## $ ave_CXCL10_ct <dbl> 31.74, 31.47, 31.40, NA, NA, 33.41, 30.38, 32.33...

### Remove observations without qRT-PCR data

The rows (observations) without any qRT-PCR data do not add anything and will be removed from both the 14x02 and 14x04 datasets. Moreover, in the `pcr_14x04` data table, the "rat" variable contains group assignment values instead of rat identifiers. The overview of the data also reveals that the corresponding observations do not contain data. Again, these observations will be removed.

``` r
## remove rows missing data from pcr_14x02
pcr_14x02 <- pcr_14x02 %>%
    filter(!rowSums(is.na(pcr_14x02[,2:7])) == 6)

## remove rows missing data from pcr_14x04
pcr_14x04 <- pcr_14x04 %>%
    filter(!rowSums(is.na(pcr_14x04[,2:7])) == 6)
```

The `pcr_14x02` dataset now has 24 observations and the `pcr_14x04` dataset now has 24 observations

### Add a 'study' variable to each qRT-PCR dataset

Here, we add a new variable for 'study' to each qRT-PCR dataset to distinguish the study as 14x02 or 14x04:

``` r
## use the mutate() function of dplyr

## add the study value of 14x02
pcr_14x02 <- pcr_14x02 %>%
    mutate(study = "14x02")

## add the study value of 14x04
pcr_14x04 <- pcr_14x04 %>%
    mutate(study = "14x04")
```

### Combine 14x02 and 14x04 qRT-PCR datasets

Next, the rows of the 14x04 qRT-PCR data can be appended to the 14x02 qRT-PCR data to generate a compile `pcr_dat` data table. The variables are then reordered.

``` r
## use the bind_rows() function of dplyr
pcr_dat <- bind_rows(pcr_14x02, pcr_14x04) 

## reorder the variables
pcr_dat <- select(pcr_dat,
                    1, 8, 2:7)
```

### Add the treatment 'group' variable to the qRT-PCR dataset

One of the experimental objectives is to determine the effect of neuroinflammation on contextual memory. Neuroinflammation was induced by systemic administration of lipopolysaccride (LPS). Secondarily, to determine if LPS caused memory deficits via cytokine release by microglia, some rats were also treated with minocycline (MIN) to block microglia activation. As a control, groups of rats were gives saline in place of either minocycline or LPS. Thus, there were four treatment groups:
1. saline-saline (SAL-SAL); control rats
2. saline-LPS (SAL-LPS); rats given saline, instead of minocycline, followed by LPS
3. minocycline-saline (MIN-saline); rats given minocycline, followed by saline
4. minocycline-LPS (MIN-LPS); rats given minocycline, followed by LPS
5. caged-control (CC); rats that not treated and are not tested in the context discrimination task

Here the treatment group variable is added to the behavioral training data:

``` r
## use the left_join() function from dplyr to add 
##    the group var and preserve the pcr_dat data

## load the grp_assigns data table
load("grp_assigns.RData")


pcr_dat <- left_join(pcr_dat, grp_assigns, 
                       by = "rat")

## reorder the variables
pcr_dat <- select(pcr_dat,
                    1,9, 2:8)
```

### Convert categorical variables to factor variables

In the tidy qRT-PCR dataset (`pcr_dat`) there are 48 observations and 9 variables. To facilitate downstream data analysis, the categorical variables 'study', and 'group' are converted to factor variables:

``` r
## use the mutate() function of dplyr
pcr_dat <- pcr_dat %>%
    mutate(study = as.factor(study),
           group = as.factor(group))
```

Overview of final form of the behavioral qRT-PCR data:

``` r
glimpse(pcr_dat)
```

    ## Observations: 48
    ## Variables: 9
    ## $ rat           <chr> "14x02_16", "14x02_17", "14x02_19", "14x02_03", ...
    ## $ group         <fctr> CC, CC, CC, SAL-SAL, SAL-SAL, SAL-SAL, SAL-SAL,...
    ## $ study         <fctr> 14x02, 14x02, 14x02, 14x02, 14x02, 14x02, 14x02...
    ## $ ave_act_ct    <dbl> 15.92, 15.88, 16.63, 15.95, 17.58, 16.24, 15.91,...
    ## $ ave_IL1_ct    <dbl> 28.64, 29.02, 29.45, 28.95, 30.31, 28.88, 28.71,...
    ## $ ave_IL6_ct    <dbl> 33.52, 29.75, 31.01, 30.13, 31.30, 30.47, 30.63,...
    ## $ ave_TNF_ct    <dbl> 27.74, 28.87, 29.18, 29.85, 31.67, 29.23, 27.99,...
    ## $ ave_BDNF_ct   <dbl> 24.70, 24.52, 27.46, 26.41, 27.09, 26.13, 24.94,...
    ## $ ave_CXCL10_ct <dbl> 30.68, 30.69, 32.59, 31.11, 32.60, 28.92, 30.45,...

A sample of 15 observations from the `pcr_dat` dataset:

``` r
## view random rows of the test_dat table
set.seed(842)

pander(head(sample_n(pcr_dat, 48), 15),
       caption = "Sample of the qRT-PCR data",
       caption.placement = "top",
       digits = 3, style = 'rmarkdown', split.table = "Inf")
```

<table style="width:100%;">
<caption>Sample of the qRT-PCR data</caption>
<colgroup>
<col width="9%" />
<col width="9%" />
<col width="7%" />
<col width="11%" />
<col width="11%" />
<col width="11%" />
<col width="11%" />
<col width="12%" />
<col width="14%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">rat</th>
<th align="center">group</th>
<th align="center">study</th>
<th align="center">ave_act_ct</th>
<th align="center">ave_IL1_ct</th>
<th align="center">ave_IL6_ct</th>
<th align="center">ave_TNF_ct</th>
<th align="center">ave_BDNF_ct</th>
<th align="center">ave_CXCL10_ct</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">14x04_10</td>
<td align="center">MIN-LPS</td>
<td align="center">14x04</td>
<td align="center">16.7</td>
<td align="center">28.1</td>
<td align="center">30.8</td>
<td align="center">28.5</td>
<td align="center">33</td>
<td align="center">30.4</td>
</tr>
<tr class="even">
<td align="center">14x02_09</td>
<td align="center">SAL-LPS</td>
<td align="center">14x02</td>
<td align="center">18.7</td>
<td align="center">30.3</td>
<td align="center">32.9</td>
<td align="center">30.3</td>
<td align="center">28</td>
<td align="center">25.1</td>
</tr>
<tr class="odd">
<td align="center">14x02_13</td>
<td align="center">MIN-SAL</td>
<td align="center">14x02</td>
<td align="center">15.7</td>
<td align="center">27.9</td>
<td align="center">28.9</td>
<td align="center">27.2</td>
<td align="center">25.9</td>
<td align="center">30</td>
</tr>
<tr class="even">
<td align="center">14x04_16</td>
<td align="center">MIN-LPS</td>
<td align="center">14x04</td>
<td align="center">17.1</td>
<td align="center">23.8</td>
<td align="center">28.8</td>
<td align="center">26.2</td>
<td align="center">34</td>
<td align="center">28.2</td>
</tr>
<tr class="odd">
<td align="center">14x04_12</td>
<td align="center">SAL-SAL</td>
<td align="center">14x04</td>
<td align="center">16.8</td>
<td align="center">27.9</td>
<td align="center">31.5</td>
<td align="center">29.2</td>
<td align="center">32.7</td>
<td align="center">32.3</td>
</tr>
<tr class="even">
<td align="center">14x02_11</td>
<td align="center">SAL-SAL</td>
<td align="center">14x02</td>
<td align="center">17.6</td>
<td align="center">30.3</td>
<td align="center">31.3</td>
<td align="center">31.7</td>
<td align="center">27.1</td>
<td align="center">32.6</td>
</tr>
<tr class="odd">
<td align="center">14x04_17</td>
<td align="center">CC</td>
<td align="center">14x04</td>
<td align="center">16.8</td>
<td align="center">27.5</td>
<td align="center">31.3</td>
<td align="center">28.7</td>
<td align="center">32.1</td>
<td align="center">31.5</td>
</tr>
<tr class="even">
<td align="center">14x04_13</td>
<td align="center">SAL-LPS</td>
<td align="center">14x04</td>
<td align="center">18.1</td>
<td align="center">25.4</td>
<td align="center">31.8</td>
<td align="center">26.4</td>
<td align="center">35</td>
<td align="center">27.7</td>
</tr>
<tr class="odd">
<td align="center">14x02_20</td>
<td align="center">MIN-SAL</td>
<td align="center">14x02</td>
<td align="center">15.8</td>
<td align="center">27.6</td>
<td align="center">29.4</td>
<td align="center">29.1</td>
<td align="center">25.6</td>
<td align="center">31.7</td>
</tr>
<tr class="even">
<td align="center">14x04_09</td>
<td align="center">CC</td>
<td align="center">14x04</td>
<td align="center">17</td>
<td align="center">29.3</td>
<td align="center">31.6</td>
<td align="center">29.4</td>
<td align="center">31.4</td>
<td align="center">31.4</td>
</tr>
<tr class="odd">
<td align="center">14x04_05</td>
<td align="center">SAL-SAL</td>
<td align="center">14x04</td>
<td align="center">17.3</td>
<td align="center">27.9</td>
<td align="center">31.8</td>
<td align="center">29.3</td>
<td align="center">32.5</td>
<td align="center">30.4</td>
</tr>
<tr class="even">
<td align="center">14x04_24</td>
<td align="center">MIN-SAL</td>
<td align="center">14x04</td>
<td align="center">17.1</td>
<td align="center">29.2</td>
<td align="center">32.8</td>
<td align="center">29.7</td>
<td align="center">34.7</td>
<td align="center">33</td>
</tr>
<tr class="odd">
<td align="center">14x04_06</td>
<td align="center">SAL-LPS</td>
<td align="center">14x04</td>
<td align="center">19.9</td>
<td align="center">28.5</td>
<td align="center">32.5</td>
<td align="center">29.8</td>
<td align="center">34.4</td>
<td align="center">31.4</td>
</tr>
<tr class="even">
<td align="center">14x02_10</td>
<td align="center">MIN-LPS</td>
<td align="center">14x02</td>
<td align="center">18.4</td>
<td align="center">29.1</td>
<td align="center">31.5</td>
<td align="center">28.3</td>
<td align="center">28.1</td>
<td align="center">28.9</td>
</tr>
<tr class="odd">
<td align="center">14x04_19</td>
<td align="center">SAL-SAL</td>
<td align="center">14x04</td>
<td align="center">17.7</td>
<td align="center">28.8</td>
<td align="center">33.5</td>
<td align="center">29.6</td>
<td align="center">33.2</td>
<td align="center">33.9</td>
</tr>
</tbody>
</table>

R session information:
----------------------

    ## Session info --------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.3.3 (2017-03-06)
    ##  system   x86_64, mingw32             
    ##  ui       RTerm                       
    ##  language (EN)                        
    ##  collate  English_United States.1252  
    ##  tz       America/Los_Angeles         
    ##  date     2017-04-04

    ## Packages ------------------------------------------------------------------

    ##  package      * version  date       source                           
    ##  assertthat     0.1      2013-12-06 CRAN (R 3.3.1)                   
    ##  backports      1.0.5    2017-01-18 CRAN (R 3.3.2)                   
    ##  base64enc      0.1-3    2015-07-28 CRAN (R 3.3.1)                   
    ##  BH             1.62.0-1 2016-11-19 CRAN (R 3.3.2)                   
    ##  bitops         1.0-6    2013-08-17 CRAN (R 3.3.1)                   
    ##  broom          0.4.2    2017-02-13 CRAN (R 3.3.2)                   
    ##  caTools        1.17.1   2014-09-10 CRAN (R 3.3.1)                   
    ##  colorspace     1.3-2    2016-12-14 CRAN (R 3.3.2)                   
    ##  curl           2.4      2017-03-24 CRAN (R 3.3.3)                   
    ##  DBI            0.6-1    2017-04-01 CRAN (R 3.3.3)                   
    ##  dichromat      2.0-0    2013-01-24 CRAN (R 3.3.1)                   
    ##  digest         0.6.12   2017-01-27 CRAN (R 3.3.2)                   
    ##  dplyr        * 0.5.0    2016-06-24 CRAN (R 3.3.1)                   
    ##  evaluate       0.10     2016-10-11 CRAN (R 3.3.1)                   
    ##  forcats        0.2.0    2017-01-23 CRAN (R 3.3.2)                   
    ##  foreign        0.8-67   2016-09-13 CRAN (R 3.3.1)                   
    ##  ggplot2      * 2.2.1    2016-12-30 CRAN (R 3.3.2)                   
    ##  gtable         0.2.0    2016-02-26 CRAN (R 3.3.1)                   
    ##  haven          1.0.0    2016-09-23 CRAN (R 3.3.2)                   
    ##  highr          0.6      2016-05-09 CRAN (R 3.3.1)                   
    ##  hms            0.3      2016-11-22 CRAN (R 3.3.2)                   
    ##  htmltools      0.3.5    2016-03-21 CRAN (R 3.3.1)                   
    ##  httr           1.2.1    2016-07-03 CRAN (R 3.3.1)                   
    ##  jsonlite       1.3      2017-02-28 CRAN (R 3.3.2)                   
    ##  knitr        * 1.15.1   2016-11-22 CRAN (R 3.3.2)                   
    ##  labeling       0.3      2014-08-23 CRAN (R 3.3.1)                   
    ##  lattice        0.20-35  2017-03-25 CRAN (R 3.3.3)                   
    ##  lazyeval       0.2.0    2016-06-12 CRAN (R 3.3.1)                   
    ##  lubridate      1.6.0    2016-09-13 CRAN (R 3.3.1)                   
    ##  magrittr       1.5      2014-11-22 CRAN (R 3.3.1)                   
    ##  markdown       0.7.7    2015-04-22 CRAN (R 3.3.1)                   
    ##  MASS           7.3-45   2016-04-21 CRAN (R 3.3.3)                   
    ##  mime           0.5      2016-07-07 CRAN (R 3.3.1)                   
    ##  mnormt         1.5-5    2016-10-15 CRAN (R 3.3.1)                   
    ##  modelr         0.1.0    2016-08-31 CRAN (R 3.3.2)                   
    ##  munsell        0.4.3    2016-02-13 CRAN (R 3.3.1)                   
    ##  nlme           3.1-131  2017-02-06 CRAN (R 3.3.2)                   
    ##  openssl        0.9.6    2016-12-31 CRAN (R 3.3.2)                   
    ##  pander       * 0.6.0    2017-03-07 Github (Rapporter/pander@b188a19)
    ##  plyr           1.8.4    2016-06-08 CRAN (R 3.3.1)                   
    ##  psych          1.7.3.21 2017-03-22 CRAN (R 3.3.3)                   
    ##  purrr        * 0.2.2    2016-06-18 CRAN (R 3.3.2)                   
    ##  R6             2.2.0    2016-10-05 CRAN (R 3.3.1)                   
    ##  RColorBrewer   1.1-2    2014-12-07 CRAN (R 3.3.1)                   
    ##  Rcpp           0.12.10  2017-03-19 CRAN (R 3.3.3)                   
    ##  readr        * 1.1.0    2017-03-22 CRAN (R 3.3.3)                   
    ##  readxl       * 0.1.1    2016-03-28 CRAN (R 3.3.2)                   
    ##  reshape2       1.4.2    2016-10-22 CRAN (R 3.3.1)                   
    ##  rmarkdown    * 1.4      2017-03-24 CRAN (R 3.3.3)                   
    ##  rprojroot      1.2      2017-01-16 CRAN (R 3.3.2)                   
    ##  rvest          0.3.2    2016-06-17 CRAN (R 3.3.1)                   
    ##  scales         0.4.1    2016-11-09 CRAN (R 3.3.2)                   
    ##  selectr        0.3-1    2016-12-19 CRAN (R 3.3.2)                   
    ##  stringi        1.1.3    2017-03-21 CRAN (R 3.3.3)                   
    ##  stringr        1.2.0    2017-02-18 CRAN (R 3.3.2)                   
    ##  tibble       * 1.3.0    2017-04-01 CRAN (R 3.3.3)                   
    ##  tidyr        * 0.6.1    2017-01-10 CRAN (R 3.3.2)                   
    ##  tidyverse    * 1.1.1    2017-01-27 CRAN (R 3.3.2)                   
    ##  xml2           1.1.1    2017-01-24 CRAN (R 3.3.2)                   
    ##  yaml           2.1.14   2016-11-12 CRAN (R 3.3.2)
