context('old-new  test')

test_that("SEM default outputs match archived results", {

  # Define the path to the netcdf file containing the meteorology inputs.
  nc_path <- system.file('extdata/AMF_USMe2_2005_L2_GF_V006.nc', package = 'PestED')

  # Format the inputs into the SEM required format.
  met_inputs <- format_inputs(nc_path)
  new <- iterate.SEM(pest = c(0, 0, 0, 0, 0), #  Disturb none of the carbon pools.
                     inputs = met_inputs, # Read in the met inputs.
                     params = PestED::default_parameters, # the list of default parameters is saved as package data.
                     years = .5) # the number of years to run SEM for.

  # Import the old SEM results
  old <- read.csv(file = './comp_data.csv')
  # Subset the comparison data so that the tests compare data not info about the version of the data that is saved.
  old <- old[ ,  !names(old) %in% c('version', 'commit')]

  expect_equal(dim(old), dim(new))
  expect_equivalent(old, new, tolerance = 1e-6)

})

