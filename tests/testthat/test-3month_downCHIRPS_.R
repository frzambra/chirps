context("downCHIRPS 2-month")
library(chirps)

prod <- "global_3-monthly"

span_times = list(
  c('1981-11-01',"1982-02-28"),
  c(Sys.Date()-60,Sys.Date())
)

down <- FALSE

testDownCH <- function(path, res,product,time_span,crop_by,
                       format,...){
  data <- downCHIRPS(path=path,product=product, res=res,time_span=time_span,
                     crop_by=crop_by,format=format,...)
  files <- list.files(path=path,pattern=paste0('.*',format,'$'))
  test <- all.equal(basename(files),data$new_name)
  file.remove(list.files(path,full.names = TRUE))
  unlink(path,recursive = TRUE)
  return(test)
}

test_that("Download CHIRPS 3-month countries chile, argentina, italy (.gz)", {
  skip_if_not(down)
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','chile'),format='gz',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','argentina'),format='gz',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','italy'),format='gz',quiet = TRUE))
})


test_that("Download CHIRPS 2-month countries chile, argentina, italy (.tif)", {
  skip_if_not(down)
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','chile'),format='tif',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','argentina'),format='tif',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('countries','italy'),format='tif',quiet = TRUE))
})

test_that("Download CHIRPS 2-month continent South America, Europe, Asia (.gz)", {
  skip_if_not(down)
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('continent','South America'),format='gz',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('continent','Europe'),format='gz',quiet = TRUE))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=prod,time_span = span_times[[1]],
                         crop_by=c('continent','Asia'),format='gz',quiet = TRUE))
})
