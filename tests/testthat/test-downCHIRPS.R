context("downCHIRPS function")
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
  c('1981-01-01',"1981-01-02"),
  c('1981-12-28',"1982-01-03"),
  c('2018-07-01',"2019-06-30"),
  c('2017-07-01',"2019-06-30"),
  c(Sys.Date()-60,Sys.Date())
)

downCHIRPS(path='~/Descargas/chirps/daily', res= .05,
           product=namesProds[5],time_span = span_times[[1]],
           crop_by=c('countries','chile'),format='gz')

downCHIRPS(path='~/Descargas/chirps/2-month',
           product=namesProds[1],time_span = span_times[[1]])

downCHIRPS(path='~/Descargas/chirps/3-month',
           product=namesProds[2],time_span = span_times[[1]])

downCHIRPS(path='~/Descargas/chirps/month',
           product=namesProds[3],time_span = span_times[[1]])

downCHIRPS(path='~/Descargas/chirps/annual',
           product=namesProds[4],time_span = span_times[[1]])


downCHIRPS(path='~/Descargas/chirps/daily', res= .25,
           product=namesProds[5],time_span = span_times[[2]],
           crop_by='chile',format='tif')

downCHIRPS(path='~/Descargas/chirps/dekad',
           product=namesProds[6],time_span = span_times[[4]])

downCHIRPS(path='~/Descargas/chirps/pentad',
           product=namesProds[6],time_span = span_times[[4]])

downCHIRPS(path='~/Descargas/chirps/daily',
           product=namesProds[4],res=.05,time_span = span_times[[5]])
