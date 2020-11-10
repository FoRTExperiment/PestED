
#' format_inputs
#'
#' Format the netcdf file form the Dietze and Matthes 2014 manuscript into a data frame that can bse used by \code{iterate.SEM}
#'
#' @param nc_path The path to the Dietze and Matthes 2014 netcdf file or a file with the same structure.
#' @return a data frame consisting of columns of the following:
#' \describe{
#' \item{time}{the day of the year}
#' \item{PAR}{incoming photosynthetically active radiation, umol/m2/s}
#' \item{temp}{air temperature, degrees C}
#' \item{VPD}{vapor pressure deficit, kPa}
#' \item{precip}{precipitation, mm}
#' }
#' @export
format_inputs <- function(nc_path){

  assertthat::assert_that(file.exists(nc_path))

  # Import the data and format it
  nc <- ncdf4::nc_open(nc_path)

  PAR <- ncdf4::ncvar_get(nc, "PAR")
  for (i in which(PAR < -10)) {
    PAR[i] <- PAR[i - 1]
  } ## uber-naive gapfilling
  temp <- ncdf4::ncvar_get(nc, "TA")
  VPD <- ncdf4::ncvar_get(nc, "VPD")
  precip <- ncdf4::ncvar_get(nc, "PREC")
  time <- ncdf4::ncvar_get(nc, "DOY")
  ncdf4::nc_close(nc)

  data.frame(time = time, PAR = PAR, temp = temp, VPD = VPD, precip = precip)

}
