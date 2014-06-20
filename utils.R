#
# file: utils.R
# A place to put various utility functions and helpers.
#


# A function to create the start of a simple codebook.
codebook_helper <- function(df = NULL, output = "codebook", widths = c(30,12)) {
  library("gdata")
  codebook <- as.data.frame(sapply(df, class))
  codebook$variable <- row.names(codebook)
  row.names(codebook) <- NULL
  codebook <- codebook[,c(2,1)]
  colnames(codebook) <- c("Variable", "Type")
  write.fwf(codebook, file=output, width=widths, colnames=FALSE)
  
  codebook
}