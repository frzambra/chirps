#' @export

.getFTPAnnual <- function(product,span_time,fold,ftp =file.path(ftp.chirps,product)){

  files <- strsplit(
    getURL(file.path(ftp,fold,'/'),
           .opts=curlOptions(ftplistonly=TRUE)), "\n")[[1]]

  files <- files[grep('[0-9]{4}.tif.gz$',files)]
  datestr <- unlist(regmatches(files,gregexpr('[0-9]{4}',files)))

  start_date <- as.Date(paste0(substr(datestr,1,4),'-01-01'))
  tmpDate <- start_date+366
  end_date <- as.Date(paste0(substr(tmpDate,1,7),'-01'))-1

  filesDF <- data.frame(files=file.path(ftp,fold,'/'),
                        start_date = start_date,
                        end_date = end_date)

  filesDF <- filesDF[filesDF$start_date >= span_time[1],]
  filesDF <- filesDF[filesDF$end_date <= span_time[2],]

  return(filesDF)

}
