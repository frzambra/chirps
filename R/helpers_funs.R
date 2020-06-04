#' @export
#'
.getFTPDaily <- function(product,span_time,res,fold='tifs',ftp =file.path(ftp.chirps,product)){

  yrs <- lapply(
    list(c(substr(span_time[1],1,4),substr(span_time[2],1,4))),
    function(x) seq(x[1],x[2],1)
  )[[1]]

  fold <- ifelse(res==.05,paste0(fold,'/p05'),paste0(fold,'/p25'))

  yrsDirs <- .listFTPfls(file.path(ftp,fold,'/'))
  yrsDirs <- yrsDirs[match(yrs,yrsDirs)]

  filesDFl <- lapply(yrsDirs,function(x) {
    files <- .listFTPfls(file.path(ftp,fold,x,'/'))
    files <- files[grep("*.gz$",files)]
    data.frame(url=file.path(ftp,fold,x,files),
               name = files,
               date=as.Date(unlist(regmatches(files,gregexpr('[0-9]{2}.*[0-9]{2}',files))),"%Y.%m.%d"))

  })

  filesDF <- do.call(rbind,filesDFl)

  filesDF <- filesDF[filesDF[,3] >= span_time[1],]
  filesDF <- filesDF[filesDF[,3] <= span_time[2],]

  return(filesDF)
}

.getFTPdekpen <- function(product,span_time,fold='tifs',ftp =file.path(ftp.chirps,product)){

  files <- .listFTPfls(file.path(ftp,fold,'/'))
  files <- files[grep('*.gz$',files)]
  datestr <- unlist(regmatches(files,gregexpr('[0-9]{2}.*[0-9]{1}',files)))

  if (identical(product,"global_dekad")){
    pents <- c('01','11','21')
  } else {
    pents <- c('01','06','11','16','21','26')
  }

  dates <- lapply(datestr, function(date){
    id <- as.numeric(substr(date,9,9))
    start_date <- as.Date(paste0(substr(date,1,8),pents[id]),'%Y.%m.%d')

    if (pents[id] == '21' | pents[id] == '26'){

      tmpDate <-  as.Date(paste0(substr(date,1,8),pents[id]),'%Y.%m.%d')
      sum <- ifelse(identical(pents[id],'21'),11,6)
      tmpDate <- tmpDate + sum
      end_date <- as.Date(paste0(substr(tmpDate,1,8),'01'))-1

    } else {

      end_date <-  as.Date(paste0(substr(date,1,8),as.numeric(pents[id])+9),'%Y.%m.%d')

    }


    return(c(start_date,end_date))
  })
  filesDF <- data.frame(url=file.path(ftp,fold,files),
                        name = files,
                        do.call(rbind,dates))

  names(filesDF)[3:4] <- c('start_date','end_date')
  filesDF[,3] <- as.Date(filesDF[,3],origin ="1970-01-01")
  filesDF[,4] <- as.Date(filesDF[,4],origin ="1970-01-01")
  filesDF <- filesDF[filesDF[,3] >= span_time[1],]
  filesDF <- filesDF[filesDF[,4] <= span_time[2],]

  return(filesDF)
}


.getFTP123mth <- function(product,span_time,fold='tifs',ftp = file.path(ftp.chirps,product)){

  files <- .listFTPfls(file.path(ftp,fold,'/'))
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

  filesDF <- data.frame(url=file.path(ftp,fold,files),
                        name = files,
                        start_date = start_date,
                        end_date = end_date)

  filesDF <- filesDF[filesDF$start_date >= span_time[1],]
  filesDF <- filesDF[filesDF$end_date <= span_time[2],]

  return(filesDF)
}


.getFTPAnnual <- function(product,span_time,fold='tifs',ftp =file.path(ftp.chirps,product)){

  files <- .listFTPfls(file.path(ftp,fold,'/'))

  files <- files[grep('[0-9]{4}.tif.gz$',files)]
  datestr <- unlist(regmatches(files,gregexpr('[0-9]{4}',files)))

  start_date <- as.Date(paste0(substr(datestr,1,4),'-01-01'))
  tmpDate <- start_date+366
  end_date <- as.Date(paste0(substr(tmpDate,1,7),'-01'))-1

  filesDF <- data.frame(url=file.path(ftp,fold,files),
                        name = files,
                        start_date = start_date,
                        end_date = end_date)

  filesDF <- filesDF[filesDF$start_date >= span_time[1],]
  filesDF <- filesDF[filesDF$end_date <= span_time[2],]

  return(filesDF)

}

.listFTPfls <- function(ftpPath){
  strsplit(getURL(ftpPath,
                  ftp.use.epsv = FALSE, ftplistonly=TRUE,crlf = TRUE), "\r*\n")[[1]]
}
