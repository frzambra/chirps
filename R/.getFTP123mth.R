#' @export

.getFTP123mth <- function(product,span_time,fold,ftp = file.path(ftp.chirps,product)){

  files <- strsplit(
    getURL(file.path(ftp,fold,'/'),
           .opts=curlOptions(ftplistonly=TRUE)), "\n")[[1]]

  files <- files[grep('*.gz$',files)]
  datestr <- unlist(regmatches(files,gregexpr('[0-9]{2}.*[0-9]{2}',files)))

  start_date <- as.Date(paste0(substr(datestr,1,7),'.01'),"%Y.%m.%d")

  if(identical(product,'global_3-monthly')) {
    tmpDate <- start_date + 100
    } else if (identical(product,'global_2-monthly')){
      tmpDate <- start_date + 70
    } else {
      tmpDate <- start_date + 40
    }

  tmpDate <- as.Date(tmpDate,"%Y.%m.%d")
  end_date <- as.Date(paste0(substr(tmpDate,1,7),'-01'))-1

  filesDF <- data.frame(file = file.path(ftp,fold,files),
                       start_date = start_date,
                       end_date = end_date)

  filesDF <- filesDF[filesDF$start_date >= span_time[1],]
  filesDF <- filesDF[filesDF$end_date <= span_time[2],]

  return(filesDF)
}
