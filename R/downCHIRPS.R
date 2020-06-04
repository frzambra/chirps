#' Download/update CHIRPS v2
#'
#' For downloading global satellite estimates of precipitation from porduct CHIRPS v2
#'
#' @param path character. Folder in which the files will be saved.
#' @param product character. Type of product to download from \url{ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/}
#' \tabular{ll}{
#' Product \tab Description \cr
#' global_2-monthly \tab Quasi-global 2-monthly fields \cr
#' global_3-monthly \tab Quasi-global 3-monthly fields \cr
#' global_annual \tab Quasi-global annual fields \cr
#' global_daily  \tab Quasi-global daily fields \cr
#' global_dekad  \tab Quasi-global dekadal fields \cr
#' global_monthly \tab Quasi-global monthly fields \cr
#' global_pentad \tab Quasi-global pentadal fields.
#' }
#' @param time_span vector with two dates, \code{c(start,end)}
#' @param res numeric. Resolution for daily product. It could be .05 or .25.
#'
#' @return
#' @export
#' @importFrom RCurl getURL curlOptions
#' @importFrom utils download.file
#' @importFrom raster crop extent writeRaster
#' @importFrom rnaturalearth ne_countries
#' @importFrom R.utils compressFile
#'
#' @examples
#'
#' #Download ten days of the global_daily product
#' #downCHIRPS(path=getwd(), product = 'global_daily', time_span = c('2019-01-01','2019-01-10'),res=.05)
#'
downCHIRPS <- function(path = getwd(), product, time_span,
                       res, format='tif', crop_by){

  if (all(is.na(match(product,namesProds)))) stop('Need a valid product name')

  if (missing(time_span)) stop("'time_span' is not provided")

  if (identical(product,'global_daily') & missing(res)){
    stop("Product 'global_daily' need a 'res' parameter")}

  if (!dir.exists(path)) dir.create(path)

  fileSel <- switch(product,
                       'global_daily' = .getFTPDaily(product,time_span,res),
                       'global_pentad' = .getFTPdekpen(product,time_span),
                       'global_dekad' = .getFTPdekpen(product,time_span),
                       'global_monthly' = .getFTP123mth(product,time_span),
                       'global_2-monthly' = .getFTP123mth(product,time_span),
                       'global_3-monthly' = .getFTP123mth(product,time_span),
                       'global_annual' = .getFTPAnnual(product,time_span)
                       )

  if (is.numeric(crop_by) | is.character(crop_by)){
    if (is.numeric(crop_by)) ext <- extent(crop_by)
    if (is.character(crop_by)){
      if (identical(crop_by[1],'continent')) {
        ext <- extent(ne_countries(continent = crop_by[2],scale='small'))}
      if (identical(crop_by[1],'countries')) {
        ext <- extent(ne_countries(country = crop_by[2],scale='small'))}
    }
    fileSel$new_name <- newName(fileSel[,2],ext,format)
  } else {
    fileSel$new_name <- fileSel[,2]
  }

  lclFls <- list.files(path,pattern =paste0('chirps-v2.0.*\\.',format,'$'))
  files2down <- fileSel[!(fileSel$new_name %in% lclFls),]

  if (nrow(files2down) != 0){
      lapply(seq_along(files2down[,1]),function(i){
        destfile <- file.path(path,files2down[i,2])
        download.file(url=files2down[i,1],
                      destfile=destfile,
                      method = 'internal')

        if (exists('ext')) {
          ras <- readTifgz(destfile)
          ras <- crop(ras,ext)

          name <- gsub('.gz','',files2down$new_name[i])
          writeRaster(ras,filename=file.path(path,name),
                      format='GTiff')

          if (identical(format,'gz')) {
            compressFile(
              file.path(path,gsub('tiff','tif',name)),
              destname = file.path(path,files2down$new_name[i]),
              ext='gz',FUN=gzfile)
          }
        }
      })
  }
  return(files2down)
}

