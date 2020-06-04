context("downCHIRPS function daily")
library(satdrought)
library(testthat)

namesProds <- c("global_2-monthly",
                "global_3-monthly",
                "global_monthly",
                "global_annual",
                "global_daily",
                "global_dekad",
                "global_pentad")

span_times = list(
  c('1980-12-311',"1981-01-01"),
  c(Sys.Date()-60,Sys.Date())
)

testDownCH <- function(path, res,product,time_span,crop_by,
                       format){
  data <- downCHIRPS(path=path,product=product, res=res,time_span=time_span,
                     crop_by=crop_by,format=format)
  files <- list.files(path=path,pattern=paste0('.*',format,'$'))
  test <- all.equal(basename(files),data$new_name)
  file.remove(list.files(path,full.names = TRUE))
  unlink(path,recursive = TRUE)
  return(test)
}

test_that("Download CHIRPS daily countries chile, argentina, italy (.gz)", {
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','chile'),format='gz'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','argentina'),format='gz'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','italy'),format='gz'))
})

data <- downCHIRPS(path=file.path(tempdir(),'test'), res= .05,
                   product=namesProds[5],time_span = span_times[[1]],
                   crop_by=c('countries','chile'),format='gz')

test_that("Download CHIRPS daily countries chile, argentina, italy (.tif)", {
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','chile'),format='tif'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','argentina'),format='tif'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('countries','italy'),format='tif'))
})

test_that("Download CHIRPS daily continent South America, Europe, Asia (.gz)", {
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('continent','South America'),format='gz'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('continent','Europe'),format='gz'))
  expect_true(testDownCH(path=file.path(tempdir(),'test'), res= .05,
                         product=namesProds[5],time_span = span_times[[1]],
                         crop_by=c('continent','Asia'),format='gz'))
})
