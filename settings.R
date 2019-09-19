
library(here)

#### input paths

#gr_hist <- here("data/cadrs/hsCourses.txt")
gr_hist <- 'S:/Data/CADRs/eScienceCollaboration/data/cadrs_collaboration_data_2019_06_18/hsCourses.txt'

ospi_crs17_fn <- here("data/cadrs/2016-17StateCourseCodes.xlsx")

ospi_crs16_fn <- here("data/cadrs/2015-16-StateCourseCodes.xlsx")

ospi_crs15_fn <- here("data/cadrs/2014_15_StateCourseCodes.csv")

ospi_crs14_fn <- here("data/cadrs/2013_14_StateCourseCodes.csv")

# renton course catalog
#rsd_crs_fn <- "~/data/rsd_unique_3.csv"
rsd_crs_fn <- here("data/rsd_unique_3.csv")

#### output paths (including intermediate files)

cadrs_training_path <- here("output/cadrs/cadrs_training.csv")

# cleaned up training set: this is the same file as cadrs_training_path
# above but with some rows hand-filtered out.
# TODO: filtering needs to be put into a script somewhere.
clean_train_fn <- here("data/ospi_stud_clean.csv")

#rsd_cadrs_training_path <- "~/data/cadrs/cadrs_training_rsd.csv"
rsd_cadrs_training_path <- here("data/cadrs/cadrs_training_rsd.csv")
