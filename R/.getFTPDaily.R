#' @param product
#'
#' @param span_time
#' @param res
#' @param fold
#' @param ftp
#'
#' @export

.getFTPDaily <- function(product,span_time,res,fold,ftp =file.path(ftp.chirps,product)){

  yrs <- lapply(
    list(c(substr(span_time[1],1,4),substr(span_time[2],1,4))),
    function(x) seq(x[1],x[2],1)
    )[[1]]

  fold <- ifelse(res==.05,paste0(fold,'/p05'),paste0(fold,'/p25'))

  yrsDirs <- strsplit(
    getURL(file.path(ftp,fold,'/'),
           .opts=curlOptions(ftplistonly=TRUE)), "\n")[[1]]

  yrsDirs <- yrsDirs[match(yrs,yrsDirs)]

  lf.ftp <- lapply(yrsDirs,function(x) {
    files <- strsplit(
      getURL(file.path(ftp,fold,x,'/'),
             .opts=curlOptions(ftplistonly=TRUE)), "\n")[[1]]
    files <- files[grep("*.gz$",files)]
    data.frame(file=file.path(ftp,fold,x,files),
               date=as.Date(unlist(regmatches(files,gregexpr('[0-9]{2}.*[0-9]{2}',files))),"%Y.%m.%d"))

  })

  #finding dates > span_time[1] and dates < span_time[2]
  lf.ftp[[1]] <- lf.ftp[[1]][lf.ftp[[1]]$date >= span_time[1],]
  lst <- length(lf.ftp)
  lf.ftp[[lst]] <- lf.ftp[[lst]][lf.ftp[[lst]]$date <= span_time[2],]

  return(lf.ftp)
}


