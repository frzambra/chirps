context("Helper function")
library(satdrought)
library(testthat)

namesProds <- c("global_2-monthly",
                "global_3-monthly",
                "global_monthly",
                "global_annual",
                "global_daily",
                "global_dekad",
                "global_pentad")

namesFiles <- c("chirps-v2.0.2019.1201.tiff.gz",
                "chirps-v2.0.1981.010203.tiff.gz",
                "chirps-v2.0.1981.01.tif.gz",
                "chirps-v2.0.1981.tif.gz",
                "chirps-v2.0.1981.01.01.tif.gz",
                "chirps-v2.0.1981.01.1.tif.gz",
                "chirps-v2.0.1981.01.3.tif.gz")

span_times = list(
  c('1981-01-01',"1981-12-31"),
  c('1981-07-01',"1982-06-30"),
  c('2018-07-01',"2019-06-30"),
  c('2017-07-01',"2019-06-30")
)

testMonth123 <- function(product,span_time){
  e <- .getFTP123mth(product,span_time)
  dim(e)
}

test_that(".getFTP123mnth to get the list of files to download monthly", {
  expect_equal(testMonth123(product=namesProds[3],span_time = span_times[[1]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[3],span_time = span_times[[2]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[3],span_time = span_times[[3]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[3],span_time = span_times[[4]]),c(24,4))

})

test_that(".getFTP123mnth to get the list of files to download two-monthly", {
  expect_equal(testMonth123(product=namesProds[1],span_time = span_times[[1]]),c(11,4))
  expect_equal(testMonth123(product=namesProds[1],span_time = span_times[[2]]),c(11,4))
  expect_equal(testMonth123(product=namesProds[1],span_time = span_times[[3]]),c(11,4))
  expect_equal(testMonth123(product=namesProds[1],span_time = span_times[[4]]),c(22,4))

})

test_that(".getFTP123mnth to get the list of files to download three-monthly", {
  expect_equal(testMonth123(product=namesProds[2],span_time = span_times[[1]]),c(10,4))
  expect_equal(testMonth123(product=namesProds[2],span_time = span_times[[2]]),c(10,4))
  expect_equal(testMonth123(product=namesProds[2],span_time = span_times[[3]]),c(10,4))
  expect_equal(testMonth123(product=namesProds[2],span_time = span_times[[4]]),c(21,4))

})

test_that(".getFTPAnnual to get the list of files to download annual", {
  expect_equal(dim(.getFTPAnnual(product=namesProds[4],span_time = span_times[[1]])),c(1,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[4],span_time = span_times[[2]])),c(0,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[4],span_time = span_times[[3]])),c(0,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[4],span_time = span_times[[4]])),c(1,4))

})

testDaily <- function(product,span_time,res){
  e <- .getFTPDaily(product,span_time,res)
  sum(unlist(lapply(e,dim)))
}

test_that(".getFTPDaily", {
  expect_equal(testDaily(product=namesProds[5],
                         span_time=span_times[[1]],res=.05),368)
  expect_equal(testDaily(product=namesProds[5],
                         span_time=span_times[[1]],res=.25),368)
  expect_equal(testDaily(product=namesProds[5],
                         span_time=span_times[[2]],res=.05),371)
  expect_equal(testDaily(product=namesProds[5],
                         span_time=span_times[[3]],res=.05),371)
  expect_equal(testDaily(product=namesProds[5],
                         span_time=span_times[[4]],res=.05),739)
})

test_that(".getFTPdekpen to download dekad files", {
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[6],
      span_time=span_times[[1]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[6],
      span_time=span_times[[2]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[6],
      span_time=span_times[[3]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[6],
      span_time=span_times[[4]])),c(72,4))
})



