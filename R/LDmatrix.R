# LDlinkR::LDmatrix

#' Generates a data frame of pairwise linkage disequilibrium
#' statistics.
#'
#' @param snps list of between 2 - 1,000 variants, using an rsID or chromosome coordinate (e.g. "chr7:24966446")
#' @param pop a 1000 Genomes Project population, (e.g. YRI or CEU), multiple allowed, default = "CEU"
#' @param r2d r2d, either "r2" for LD R2 or "d" for LD D', default = "r2"
#' @param token LDlink provided user token, default = NULL, register for token at \url{https://ldlink.nci.nih.gov/?tab=apiaccess}
#' @param file Optional character string naming a path and file for saving results.  If file = FALSE, no file will be generated, default = FALSE.
#'
#' @return a data frame
#' @importFrom httr POST content http_error stop_for_status
#' @importFrom utils capture.output read.delim write.table
#' @export
#'
#' @examples
#' \dontrun{LDmatrix(c("rs3", "rs4", "rs148890987"),
#'                     "YRI", "r2",
#'                     token = Sys.getenv("LDLINK_TOKEN"))
#'                  }
#'
LDmatrix <- function(snps, pop="CEU", r2d="r2", token=NULL, file = FALSE) {

LD_config <- list(ldmatrix_url="https://ldlink.nci.nih.gov/LDlinkRest/ldmatrix",
                  avail_pop=c("YRI","LWK","GWD","MSL","ESN","ASW","ACB",
                              "MXL","PUR","CLM","PEL","CHB","JPT","CHS",
                              "CDX","KHV","CEU","TSI","FIN","GBR","IBS",
                              "GIH","PJL","BEB","STU","ITU",
                              "ALL", "AFR", "AMR", "EAS", "EUR", "SAS"),
                  avail_ld=c("r2", "d")
                )


url <- LD_config[["ldmatrix_url"]]
avail_pop <- LD_config[["avail_pop"]]
avail_ld <- LD_config[["avail_ld"]]

# ensure file option is a character string
  file <- as.character(file)

# Define regular expressions used to check arguments for valid input below
  rsid_pattern <- "^rs\\d{1,}"
  # Syntax               Description
  # ^rs                  rsid starts with 'rs'
  # \\d{1,}              followed by 1 or more digits

  chr_coord_pattern <- "(^chr)(\\d{1,2}|X|x|Y|y):(\\d{1,9})$"
  # Syntax               Description
  # (^chr)               chromosome coordinate starts with 'chr'
  # (\\d{1,2}|X|x|Y|y)   followed by one or two digits, 'X', 'x', 'Y', 'y', to designate chromosome
  # :                    followed by a colon
  # (\\d{1,9})$          followed by 1 to 9 digits only to the end of string


# Checking arguments for valid input
  if(!(length(snps) > 1) & (length(snps) <= 1000)) {
    stop("Input is between 2 to 1000 variants.")
  }

  for(i in 1:length(snps)) {
    if(!((grepl(rsid_pattern, snps[i], ignore.case = TRUE)) | (grepl(chr_coord_pattern, snps[i], ignore.case = TRUE))))  {
      stop(paste("Invalid query format for variant: ",snps[i], ".", sep=""))
    }
  }

  if(!(all(pop %in% avail_pop))) {
    stop("Not a valid population code.")
  }

  if(!(r2d %in% avail_ld)) {
    stop("Not a valid r2d.  Enter 'r2' or 'd'.")
  }

  if(is.null(token)) {
    stop("Enter valid access token. Please register using the LDlink API Access tab: https://ldlink.nci.nih.gov/?tab=apiaccess")
  }

  if(!(is.character(file) | file == FALSE)) {
    stop("Invalid input for file option.")
  }


# Request body
snps_to_upload <- paste(unlist(snps), collapse = "\n")
pop_to_upload <- paste(unlist(pop), collapse = "+")
jsonbody <- list(snps=snps_to_upload, pop=pop_to_upload, r2_d=r2d)

# URL string
url_str <- paste(url, "?", "&token=", token, sep="")

# before 'POST command', check if LDlink server is up and accessible...
# if server is down pkg should fail gracefully with informative message (not error)
if (httr::http_error(url)) { # if server is down use message (and not an error)
  message("The LDlink server is down or not accessible. Please try again later.")
  return(NULL)
} else { # network is up then proceed
  message("\nLDlink server is working...\n")
}

# POST command
raw_out <-  httr::POST(url=url_str, body=jsonbody, encode="json")
httr::stop_for_status(raw_out)
# Parse response object
data_out <- read.delim(textConnection(httr::content(raw_out, "text", encoding = "UTF-8")), header=T, sep="\t")

# Check for error in response data
  if(grepl("error", data_out[2,1])) {
    stop(data_out[2,1])
  }

# Evaluate 'file' option
  if (file == FALSE) {
    return(data_out)
  } else if (is.character(file)) {
    print(data_out)
    write.table(data_out, file = file, quote = F, row.names = F, sep = "\t")
    cat(paste("\nFile saved to ",file,".", sep=""))
    return(data_out)
  }

}
############ End Primary Function ##################
