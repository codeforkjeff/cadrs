
# Loads all input files into sqlite.

library(data.table)
library(here)
library(openxlsx)
library(readr)
library(RSQLite)
library(stringi)
library(sys)
library(tidyverse)

source(here("settings.R"))
source(here("R/lib.R"))

######

import_table_using_dbi(dim_student_path, "dimStudent", sep="|", quote="", file_encoding="UTF-8-BOM")
import_table_using_dbi(dim_school_path, "dimSchool", sep="|", quote="", file_encoding="UTF-8-BOM")
import_table_using_dbi(enrollment_path, "enrollment", sep="|", quote="", file_encoding="UTF-8-BOM")
#import_table_using_dbi(gr_hist, "courses", sep="|", quote="", file_encoding="UTF-8-BOM")

# some code depends on proper types for certain fields, so we're specific about them for this table
df_h <- read_delim(gr_hist, delim = "|", quote = "",col_names = TRUE, na = c("", "NA", "NULL"),
  col_types = cols(
    ReportSchoolYear = col_double(),
    DistrictCode = col_character(),
    DistrictName = col_character(),
    SchoolCode = col_character(),
    SchoolName = col_character(),
    LocationID = col_character(),
    ResearchID = col_double(),
    TermEndDate = col_character(),# col_date(format = "%Y-%m-%d"),
    Term = col_character(),
    CourseID = col_character(),
    CourseTitle = col_character(),
    StaffID = col_character(),
    GradeLevelWhenCourseTaken = col_double(),
    LetterGrade = col_character(),
    CreditsAttempted = col_double(),
    CreditsEarned = col_double(),
    StateCourseCode = col_character(),
    StateCourseName = col_character(),
    ContentAreaCode = col_character(),
    ContentAreaName = col_character(),
    APIBCourseCode = col_character(),
    APIBCourseName = col_character(),
    CTECIPCode = col_character(),
    CTECIPName = col_character(),
    CTEClusterID = col_character(),
    CTEClusterName = col_character(),
    CTEPathwayID = col_character(),
    CTEPathwayName = col_character(),
    CTEAssessment = col_character(),
    hasCTEIndustryCertificateFlag = col_double(),
    CTEVocCompleterFlag = col_double(),
    CTEDirectTranscriptionAvailableFlag = col_logical(),
    TechPrepCourseFlag = col_double(),
    TechPrepProgramAreaCompleterFlag = col_double(),
    FullCourseDesignationCode = col_character(),
    InternationalBaccalaureateFlag = col_double(),
    CollegeattheHighSchoolFlag = col_double(),
    HonorsFlag = col_double(),
    AdvancedPlacementFlag = col_double(),
    RunningStartFlag = col_double(),
    CollegeAcademicDistributionRequirementsFlag = col_double(),
    CambridgeProgramFlag = col_double(),
    OnlineFlag = col_double(),
    dPassedFlag = col_double(),
    dTermEndYear = col_double(),
    dTermEndWeekOfYear = col_double(),
    dSchoolYear = col_double()
  )
)
import_table_from_dataframe(df_h, 'courses')
rm(df_h)

######

ospi_crs17 <- read.xlsx(ospi_crs17_fn, 4, startRow = 2) %>%
  select(State.Course.Code:X6) %>%
  rename(content_area = X6)

ospi_crs17$`State.Course.Code` <- stri_encode(ospi_crs17$`State.Course.Code`, "", "UTF-8")
ospi_crs17$Name <- stri_encode(ospi_crs17$Name, "", "UTF-8")
ospi_crs17$Description <- stri_encode(ospi_crs17$Description, "", "UTF-8")
ospi_crs17$content_area <- stri_encode(ospi_crs17$content_area, "", "UTF-8")

import_table_from_dataframe(ospi_crs17, 'ospi_crs17')

ospi_crs16 <- read.xlsx(ospi_crs16_fn, 4, startRow = 2) %>%
  select(State.Course.Code:X6) %>%
  rename(content_area = X6)

ospi_crs16$`State.Course.Code` <- stri_encode(ospi_crs16$`State.Course.Code`, "", "UTF-8")
ospi_crs16$Name <- stri_encode(ospi_crs16$Name, "", "UTF-8")
ospi_crs16$Description <- stri_encode(ospi_crs16$Description, "", "UTF-8")
ospi_crs16$content_area <- stri_encode(ospi_crs16$content_area, "", "UTF-8")

import_table_from_dataframe(ospi_crs16, 'ospi_crs16')

ospi_crs15 <- fread(ospi_crs15_fn, skip = 2, header = T, drop = c("V1","V5"), encoding='UTF-8') %>%
  rename(State.Course.Code = `State Course Code`) %>%
  mutate(State.Course.Code = as.character(State.Course.Code),
         State.Course.Code = str_pad(State.Course.Code, 5, pad = "0"))

ospi_crs15$`State.Course.Code` <- stri_encode(ospi_crs15$`State.Course.Code`, "", "UTF-8")
ospi_crs15$Name <- stri_encode(ospi_crs15$Name, "", "UTF-8")
ospi_crs15$Description <- stri_encode(ospi_crs15$Description, "", "UTF-8")

ospi_crs15 <- left_join(ospi_crs15, ospi_crs16 %>%
                          select(State.Course.Code, content_area), by = 'State.Course.Code')

import_table_from_dataframe(ospi_crs15, 'ospi_crs15')

######

rsd_crs <- fread(rsd_crs_fn, na.strings = c("NA", "NULL"), encoding='UTF-8') %>%
  mutate(State.Course.Code = as.character(`State Code`),
         State.Course.Code = str_pad(State.Course.Code, 5, pad = "0"),
         cadr = if_else(`CADR Flag` == 'Yes', 1,0),
         State.Course.Code = str_remove(State.Course.Code, "[A-Z]$"))

import_table_from_dataframe(rsd_crs, 'rsd_crs')

######

fileConn <- file("SQL/create_course_2017_cohort.sql", "r")
lines <- readLines(fileConn)
close(fileConn)

exec_sqlite(lines)

######

fileConn <- file("SQL/create_enroll_2017_cohort.sql", "r")
lines <- readLines(fileConn)
close(fileConn)

exec_sqlite(lines)
