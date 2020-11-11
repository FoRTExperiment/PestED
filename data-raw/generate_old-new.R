## This script generates the comparison data used in "test-old_new" unit testing.
## The objective of the test is to do a bit for bit comparison, to make sure that
## minor devlopment does not impact SEM results. However, when there
## is an expected major SEM development there may be an expected change in the output behavior.
## If/when this is the case use this script to generate new comparison data.

# Since this script will only be run occasionally while actively developing the package, use
# devtools::load_all() instead of loading the built package.
devtools::load_all()

# Define the path to the netcdf file containing the meteorology inputs.
nc_path <- system.file('extdata/AMF_USMe2_2005_L2_GF_V006.nc', package = 'PestED')

# Determine the version of package and the git commit, that generates the comparison data.
# This will be saved to help keep track of the last time the comparison data
# was actually updated.
pkg_version <- packageVersion('PestED')
pkg_commit  <- system("git rev-parse --short HEAD", intern = TRUE)

# Format the inputs into the SEM required format.
met_inputs <- format_inputs(nc_path)

baseline <- iterate.SEM(pest = c(0, 0, 0, 0, 0), #  Disturb none of the carbon pools.
                        inputs = met_inputs, # Read in the met inputs.
                        params = PestED::default_parameters, # the list of default parameters is saved as package data.
                        years = .5) # the number of years to run SEM for.

baseline$version <- pkg_version
baseline$commit  <- pkg_commit

# Save the output as comparison
write.csv(x = baseline, file = here::here('tests', 'testthat', 'comp_data.csv'), row.names = FALSE)

