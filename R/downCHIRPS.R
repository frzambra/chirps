downCHIRPS <- function(dir){
  
  ftp <- 'ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/global_dekad/tifs/'
  
  #out.dir <- "/media/francisco/HDD4TB_2/data/rasters/raw/CHIRPS/CHIRPS-2.0.dekad/"
  
  library(RCurl)
  #years with perssian-CDR data
  
  lf.ftp <- strsplit(getURL(paste0(ftp,'/'), .opts=curlOptions(ftplistonly=TRUE)), "\n")[[1]]
  lf.ftp <-lf.ftp[grep('*.gz$',lf.ftp)]
  
  lf.dir <- list.files(dir,pattern='*.gz$')
  files2downs <- lf.ftp[!(lf.ftp %in% lf.dir)]
  
  if (length(files2downs)>20) resp <- askYesNo('Will start to downloading > 20 files, do you wish to continue')
  
  if (exists('resp') ){
    if(!resp) stop('Exit function')
  }
  
  lapply(files2downs,function(x){
    download.file(file.path(ftp,x),paste0(dir,'/',x),method='wget',quiet=TRUE)
    })
}




