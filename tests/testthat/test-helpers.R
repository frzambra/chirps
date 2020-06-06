context("Helper function .getFTP")
library(chirps)

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
  expect_equal(testMonth123(product=namesProds[6],span_time = span_times[[1]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[6],span_time = span_times[[2]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[6],span_time = span_times[[3]]),c(12,4))
  expect_equal(testMonth123(product=namesProds[6],span_time = span_times[[4]]),c(24,4))

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
  expect_equal(dim(.getFTPAnnual(product=namesProds[3],span_time = span_times[[1]])),c(1,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[3],span_time = span_times[[2]])),c(0,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[3],span_time = span_times[[3]])),c(0,4))
  expect_equal(dim(.getFTPAnnual(product=namesProds[3],span_time = span_times[[4]])),c(1,4))

})

testDaily <- function(product,span_time,res){
  e <- .getFTPDaily(product,span_time,res)
  dim(e)
}

test_that(".getFTPDaily aa", {
  expect_equal(testDaily(product=namesProds[4],span_time=span_times[[1]],res=.05),c(365,3))
  expect_equal(testDaily(product=namesProds[4],span_time=span_times[[1]],res=.25),c(365,3))
  expect_equal(testDaily(product=namesProds[4],span_time=span_times[[2]],res=.05),c(365,3))
  expect_equal(testDaily(product=namesProds[4],span_time=span_times[[3]],res=.05),c(365,3))
  expect_equal(testDaily(product=namesProds[4],span_time=span_times[[4]],res=.05),c(730,3))
})

test_that(".getFTPdekpen to download dekad files", {
  expect_equal(dim(.getFTPdekpen(
    product=namesProds[5],
      span_time=span_times[[1]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[5],
      span_time=span_times[[2]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[5],
      span_time=span_times[[3]])),c(36,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[5],
      span_time=span_times[[4]])),c(72,4))
})

test_that(".getFTPdekpen to download pentad files", {
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[7],
      span_time=span_times[[1]])),c(72,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[7],
      span_time=span_times[[2]])),c(72,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[7],
      span_time=span_times[[3]])),c(72,4))
  expect_equal(dim(
    .getFTPdekpen(
      product=namesProds[7],
      span_time=span_times[[4]])),c(144,4))
})



