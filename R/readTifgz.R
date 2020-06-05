#' Title
#'
#' @param file
#'
#' @return
#' @export
<<<<<<< HEAD:R/readTifgz.R
#'
#' @importFrom raster raster
=======
#' @importMethodsFrom R.utils gunzip
>>>>>>> 5a62ec8ee7baeb3b0f82f97b941eb00f31219925:R/radTifgz.R
#' @importMethodsFrom raster raster
#' @importFrom R.utils gunzip
#'
#' @examples
readTifgz <- function(file){
  tmpfile <- paste0(tempfile(),'.tif')
  tifFile <- gunzip(file,destname=tmpfile)
  ras <- raster(tmpfile)
  return(ras)
}

newName <- function(names,ext,format){

  sapply(names,function(name){
    nameExt <- strsplit(as.character(as.list(ext)),'\\.')
    pExt <- sapply(nameExt,'[',1)
    pre <- paste0(c(num2let(pExt[1:2],'lon'),num2let(pExt[3:4],'lat')),collapse='.')

    ifelse(identical(format,'tif'),
           paste0(gsub('.tif.gz',paste0('_',pre,'.tif'),name)),
           paste0(gsub('.tif.gz',paste0('_',pre,'.tif.gz'),name)))
  })
}

num2let <- function(coor,type= 'lat'){

  switch(type,
         'lat' =ifelse(coor>=0,
                       paste0(substr(coor,2,nchar(coor)),'N'),
                       paste0(substr(coor,2,nchar(coor)),'S')),
         'lon' = ifelse(coor>=0,
                        paste0(substr(coor,2,nchar(coor)),'E'),
                        paste0(substr(coor,2,nchar(coor)),'W'))
  )

}
