#' Download/update CHIRPS v2
#'
#' For downloading global satellite estimates of precipitation from porduct CHIRPS v2
#'
#' @param path character. Folder in which the files will be saved.
#' @param product character. Type of product to download from \url{ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/}
#' \tabular{lll}{
#' Product \tab Description \tab Format \cr
#' global_2-monthly \tab Quasi-global 2-monthly fields \tab TIF. \cr
#' global_3-monthly \tab Quasi-global 3-monthly fields \tab TIF. \cr
#' global_annual \tab Quasi-global annual fields \tab NetCDF and TIF \cr
#' global_daily  \tab Quasi-global daily fields \tab NetCDF and TIF \cr
#' global_dekad  \tab Quasi-global dekadal fields \tab BIL, NetCDF and TIF \cr
#' global_monthly \tab Quasi-global monthly fields \tab BIL, NetCDF and TIF \cr
#' global_pentad \tab Quasi-global pentadal fields. \tab BIL, NetCDF and TIF
#' }
#' @param time_span vector with two dates, \code{c(start,end)}
#' @param res numeric. Resolution for daily product. It could be .05 or .25.
#'
#' @return
#' @export
#' @importFrom RCurl getURL curlOptions
#' @importFrom utils download.file askYesNo
#'
#' @examples
downCHIRPS <- function(path = getwd(), product='global_dekad', time_span=NULL,
                       res=NULL){

  if (all(is.na(match(product,namesProds)))) stop('Need a valid product name')


  fileSel <- switch(product,
                       'global_daily' = .getFTPDaily(product,time_span,res),
                       'global_pentad' = .getFTPdekpen(product,time_span),
                       'global_dekad' = .getFTPdekpen(product,time_span),
                       'global_monthly' = .getFTP123mth(product,time_span),
                       'global_2-monthly' = .getFTP123mth(product,time_span),
                       'global_3-monthly' = .getFTP123mth(product,time_span),
                       'global_annual' = .getFTPAnnual(product,time_span)
                       )

  lclFls <- list.files(path,pattern ='chirps-v2.0*.gz$')

  if (identical(product,'global_daily')){
    files2down <- lapply(fileSel,function(files){
      files[!(files$name %in% lclFls),]
    })

    nFls <- lapply(files2down, nrow)


    if (sum(unlist(nFls))!=0)
      lapply(files2down,function(lstFiles){
        download.file(url=lstFiles$url,
                      destfile=file.path(path,lstFiles$name),
                      method = 'wget')
      })
  } else {
    files2down <- fileSel[!(fileSel$name %in% lclFls),]

    if (nrow(files2down) != 0)
      lapply(seq_along(files2down$url), function(i){
        download.file(files2down$url[i],
                      destfile=file.path(path,files2down$name[i]),
                      method = 'wget')
      })
  }
  return(files2down)
}

