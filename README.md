# LDlinkR <img src="man/figures/logo.png" align="right" height=140/>

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version-ago/LDlinkR)](https://cran.r-project.org/package=LDlinkR)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/grand-total/LDlinkR?color=blue)](https://r-pkg.org/pkg/LDlinkR)
![CRAN/METACRAN](https://img.shields.io/cran/l/LDlinkR?color=yellow)
<!-- badges: end -->

### An R Package for Calculating Linkage Disequilibrium

## Description

[LDlink](https://ldlink.nci.nih.gov) is an interactive and powerful suite of web-based tools for querying germline variants in human population groups of interest to generate interactive tables and plots.  All population genotype data originates from Phase 3 (Version 5) of the [1000 Genomes Project](https://www.internationalgenome.org/) and variant RS (reference SNP) numbers are indexed based on dbSNP build 151.

*LDlinkR* is an R package developed to query and download results generated by [LDlink](https://ldlink.nci.nih.gov) web-based applications from the R console.  It facilitates researchers who are interested in performing batch queries.  *LDlinkR* accelerates genomic research by providing efficient and user-friendly functions to programmatically interrogate pairwise linkage disequilibrium from large lists of genetic variants. 

## Installation
- The release version of *LDlinkR* can be installed from [CRAN](https://cran.r-project.org/) with:
``` r
install.packages("LDlinkR")
```
- The development version of the *LDlinkR* package can be installed from the [GitHub repository](https://github.com/CBIIT/LDlinkR) by using the `remotes` package:
``` r 
install.packages("remotes")
remotes::install_github("CBIIT/LDlinkR")
```
*LDlinkR* depends on the following packages:

- *utils*, version 3.4.2 or later
- *httr*, version 1.4.0 or later

Following installation, attach the *LDlinkR* package with:
``` r
library(LDlinkR)
```

## Personal Access Token - **Required**

In order to access the [LDlink](https://ldlink.nci.nih.gov) API via *LDlinkR*, we use a personal access token. This is a common convention followed by many APIs and emulates the more familiar HTTPS username/password or SSH keys.

You will need to:

- Make a one-time request for your personal access token from a web browser at <https://ldlink.nci.nih.gov/?tab=apiaccess>.
- Once registered, your personal access token will be emailed to you. It is a string of 12 random letters and numbers. 
- Provide your token as an argument when using *LDlinkR*.  See example below:

``` r
LDhap(snps = c("rs3", "rs4", "rs148890987"), 
      pop = "YRI", 
      token = "YourTokenHere123")
```

<br>

## Available Functions
| Function| Description|
|:--------|:-----------|
|`LDexpress`|Search if a list of genomic variants is associated with gene expression in tissues of interest.|
|`LDhap` |Calculates population specific haplotype frequencies of all haplotypes observed for a list of query variants.|
|`LDmatrix` |Generates a data frame of pairwise linkage disequilibirum statistics.|
|`LDpair`|Investigates potentially correlated alleles for a pair of variants.|
|`LDpop` |Investigates allele frequencies and linkage disequilibrium patterns across 1000G populations.|
|`LDproxy` |Explore proxy and putatively functional variants for a single query variant.|
|`LDproxy_batch`|Query `LDproxy` using a list of query variants.|
|`SNPchip` |Find commercial genotyping chip arrays for variants of interest.|
|`SNPclip` |Prune a list of variants by linkage disequilibrium.|

<br>

## Utilities
|Utility Function |Description|
|:--------|:-----------|
|`list_chips` |Provides a data frame listing the names and abbreviation codes for available commerical SNP Chip Arrays from Illumina and Affymetrix.|
|`list_pop` |Provides a data frame listing the available reference populations from the [1000 Genomes Project](https://www.internationalgenome.org/).|
|`list_gtex_tissues` |Provides a data frame listing the GTEx full names, `LDexpress` full names (without spaces) and acceptable abbreviation codes of the 54 non-diseased tissue sites collected for the [GTEx Portal](https://gtexportal.org/home/) and used as input for the `LDexpress` function.|

<br>

## Basic example

In this basic example, the `LDproxy` function is used to explore proxy and putatively functional variants for a single query variant. Usage by other functions is similar.


```{r}
my_proxies <- LDproxy(snp = "rs456", 
                      pop = "YRI", 
                      r2d = "r2", 
                      token = Sys.getenv("LDLINK_TOKEN")
                     )
```
This example uses a single reference SNP ID (rsID) for the query variant, a population of interest (YRI = Yoruba in Ibadan, Nigera) and "r2" for the desired output to be based on estimated R^2^. The output is stored in the variable `my_proxies`.  **Note:** Replace "YourTokenHere123" with your personal access token. See section above, "Personal Access Token".

<br>

The output can be viewed by using the R Utils Package `head` function to return the first parts of the object `my_proxies`.

```{r}
head(my_proxies)
```

```
##    RS_Number         Coord Alleles    MAF Distance Dprime     R2
## 1      rs456 chr7:24962419   (G/C) 0.1944        0      1 1.0000
## 2      rs457 chr7:24962426   (T/C) 0.1944        7      1 1.0000
## 3 rs28475742 chr7:24964633   (G/T) 0.1944     2214      1 1.0000
## 4      rs123 chr7:24966446   (C/A) 0.1944     4027      1 1.0000
## 5      rs125 chr7:24959703   (C/T) 0.2037    -2716      1 0.9436
## 6      rs128 chr7:24958977   (C/T) 0.2037    -3442      1 0.9436
##   Correlated_Alleles RegulomeDB Function
## 1            G=G,C=C          5     <NA>
## 2            G=T,C=C          5     <NA>
## 3            G=G,C=T          4     <NA>
## 4            G=C,C=A         1f     <NA>
## 5            G=C,C=T          5     <NA>
## 6            G=C,C=T          7     <NA>
```

<br>

## Another example

This example demonstrates the use of the `LDexpress` function to search if a genomic variant (or list of variants) is associated with gene expression in tissues of interest. Usage by other functions is similar.  

```{r}
my_output <- LDexpress(snps = "rs4",
                       pop = c("YRI", "CEU"),
                       tissue =  c("ADI_SUB", "ADI_VIS_OME"),
                       token = "YourTokenHere123"
                      )
```

For the function arguments, this example uses a single rsID for a query variant, multiple populations (e.g. YRI = Yoruba in Ibadan, Nigera and CEU = Utah Residents from North and West Europe) and multiple tissue types using acceptable abbreviations for available tissues (e.g. ADI_SUB = Adipose - Subcutaneous and ADI_VIS_OME = Adipose - Visceral (Omentum)). The output is stored in the variable `my_output`.  **Note:** Replace "YourTokenHere123" with your personal access token. See section above, "Personal Access Token".

<br>

In order to view the output, use the R Utils Package `head` function to return the first parts of the object `my_output`.

```{r}
head(my_output)
```

```
##   Query      RS_ID       Position                R2                D'
## 1   rs4 rs10637519 chr13:32430479 0.174249321651574 0.965976331360947
## 2   rs4 rs10637519 chr13:32430479 0.174249321651574 0.965976331360947
## 3   rs4   rs473641 chr13:32431244 0.174249321651574 0.965976331360947
## 4   rs4   rs473641 chr13:32431244 0.174249321651574 0.965976331360947
## 5   rs4   rs671746 chr13:32431263 0.174249321651574 0.965976331360947
## 6   rs4   rs671746 chr13:32431263 0.174249321651574 0.965976331360947
##    Gene_Symbol        Gencode_ID                       Tissue
## 1 RP1-257C22.2 ENSG00000279314.1       Adipose - Subcutaneous
## 2 RP1-257C22.2 ENSG00000279314.1 Adipose - Visceral (Omentum)
## 3 RP1-257C22.2 ENSG00000279314.1       Adipose - Subcutaneous
## 4 RP1-257C22.2 ENSG00000279314.1 Adipose - Visceral (Omentum)
## 5 RP1-257C22.2 ENSG00000279314.1       Adipose - Subcutaneous
## 6 RP1-257C22.2 ENSG00000279314.1 Adipose - Visceral (Omentum)
##   Non_effect_Allele_Freq Effect_Allele_Freq Effect_Size     P_value
## 1                G=0.565          GTC=0.435    0.225642  2.2578e-07
## 2                G=0.565          GTC=0.435    0.207161  1.0227e-05
## 3                A=0.565            G=0.435    0.225642  2.2578e-07
## 4                A=0.565            G=0.435    0.207161  1.0227e-05
## 5                C=0.565            T=0.435    0.226558 1.93289e-07
## 6                C=0.565            T=0.435    0.207161  1.0227e-05
```
<br>

## Utility function example

The following example demonstrates the usage of the utility function `list_pop` which returns a listing of the available reference populations from the [1000 Genomes Project](https://www.internationalgenome.org/) and their corresponding population code and super population code used by *LDlinkR* functions. Usage of the other utility functions is similar.

```{r}
list_pop()
```

```
##    pop_code super_pop_code                                  pop_name
## 1       ALL            ALL                           ALL POPULATIONS
## 2       AFR            AFR                                   AFRICAN
## 3       YRI            AFR                  Yoruba in Ibadan, Nigera
## 4       LWK            AFR                    Luhya in Webuye, Kenya
## 5       GWD            AFR                 Gambian in Western Gambia
## 6       MSL            AFR                     Mende in Sierra Leone
## 7       ESN            AFR                            Esan in Nigera
## 8       ASW            AFR   Americans of African Ancestry in SW USA
## 9       ACB            AFR           African Carribbeans in Barbados
## 10      AMR            AMR                         AD MIXED AMERICAN
## 11      MXL            AMR    Mexican Ancestry from Los Angeles, USA
## 12      PUR            AMR            Puerto Ricans from Puerto Rico
## 13      CLM            AMR        Colombians from Medellin, Colombia
## 14      PEL            AMR                 Peruvians from Lima, Peru
## 15      EAS            EAS                                EAST ASIAN
## 16      CHB            EAS              Han Chinese in Bejing, China
## 17      JPT            EAS                  Japanese in Tokyo, Japan
## 18      CHS            EAS                      Southern Han Chinese
## 19      CDX            EAS       Chinese Dai in Xishuangbanna, China
## 20      KHV            EAS         Kinh in Ho Chi Minh City, Vietnam
## 21      EUR            EUR                                  EUROPEAN
## 22      CEU            EUR Utah Residents from North and West Europe
## 23      TSI            EUR                         Toscani in Italia
## 24      FIN            EUR                        Finnish in Finland
## 25      GBR            EUR           British in England and Scotland
## 26      IBS            EUR               Iberian population in Spain
## 27      SAS            SAS                               SOUTH ASIAN
## 28      GIH            SAS  Gujarati Indian from Houston, Texas, USA
## 29      PJL            SAS             Punjabi from Lahore, Pakistan
## 30      BEB            SAS                   Bengali from Bangladesh
## 31      STU            SAS              Sri Lankan Tamil from the UK
## 32      ITU            SAS                 Indian Telugu from the UK
```

<br>

## Additional examples
More detailed examples demonstrating the usage of each function can be found in the package vignette.

```{r}
browseVignettes("LDlinkR")
```



## Contributors

Timothy A. Myers, Stephen J. Chanock and Mitchell J. Machiela

