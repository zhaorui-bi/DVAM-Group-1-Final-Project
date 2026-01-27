# ============================================================
# GBIF occurrence cleaning pipeline
# - Taxonomic name standardization (GBIF backbone fields)
# - Coordinate cleaning with CoordinateCleaner
#
# Outputs:
#   occurrence_clean.csv
#   cleaning_log.csv
# ============================================================

suppressPackageStartupMessages({
  library(data.table)
  library(dplyr)
  library(CoordinateCleaner)
})

# --------------------------- user parameters ---------------------------
infile  <- "world_occurrences.csv"     # GBIF download (unzipped)
outfile <- "occurrence_clean.csv"
logfile <- "cleaning_log.csv"

# Name standardization: priority order
name_priority <- c("acceptedScientificName", "scientificName", "species")

# CoordinateCleaner tests (as in manuscript)
cc_tests <- c("sea", "capitals", "centroids", "institutions")

# --------------------------- helpers ---------------------------
read_gbif <- function(path) {
  if (!file.exists(path)) stop("Input file not found: ", path)
  # GBIF exports are often tab-delimited, occasionally comma-delimited
  tryCatch(
    fread(path, sep = "\t", quote = "", data.table = FALSE, encoding = "UTF-8"),
    error = function(e) fread(path, sep = ",", quote = "", data.table = FALSE, encoding = "UTF-8")
  )
}

pick_first_existing <- function(candidates, cols) {
  hit <- candidates[candidates %in% cols]
  if (length(hit) == 0) return(NA_character_)
  hit[1]
}

as_logical_strict <- function(x) {
  # Accept logical, factor, character ("TRUE"/"FALSE")
  if (is.logical(x)) return(replace(x, is.na(x), FALSE))
  if (is.factor(x)) x <- as.character(x)
  if (is.character(x)) {
    y <- as.logical(x)
    return(replace(y, is.na(y), FALSE))
  }
  # last resort
  y <- suppressWarnings(as.logical(x))
  replace(y, is.na(y), FALSE)
}

extract_cleaned_from_cc <- function(cc, original_df) {
  # CoordinateCleaner return behavior varies by version.
  # Handle: logical vector; data.frame with summary column; data.frame already cleaned; list with $data.
  if (is.logical(cc) && length(cc) == nrow(original_df)) {
    return(original_df[cc, , drop = FALSE])
  }
  
  if (is.data.frame(cc)) {
    # If a summary/clean column exists, filter by it; otherwise treat cc as cleaned data.
    cand_cols <- c(".summary", "summary", ".clean", "clean")
    col <- pick_first_existing(cand_cols, names(cc))
    if (!is.na(col)) {
      keep <- as_logical_strict(cc[[col]])
      return(cc[keep, , drop = FALSE])
    }
    return(cc)
  }
  
  if (is.list(cc) && "data" %in% names(cc) && is.data.frame(cc$data)) {
    return(cc$data)
  }
  
  stop("Unrecognized CoordinateCleaner output type: ", paste(class(cc), collapse = ", "))
}

# --------------------------- pipeline ---------------------------
counts <- list()

dt <- read_gbif(infile)
counts$raw <- nrow(dt)

required <- c("decimalLongitude", "decimalLatitude")
missing_required <- setdiff(required, names(dt))
if (length(missing_required) > 0) {
  stop("Missing required columns: ", paste(missing_required, collapse = ", "))
}

dt <- dt %>%
  mutate(
    decimalLongitude = suppressWarnings(as.numeric(decimalLongitude)),
    decimalLatitude  = suppressWarnings(as.numeric(decimalLatitude))
  ) %>%
  filter(
    !is.na(decimalLongitude), !is.na(decimalLatitude),
    decimalLongitude >= -180, decimalLongitude <= 180,
    decimalLatitude  >= -90,  decimalLatitude  <= 90
  )
counts$lonlat_valid <- nrow(dt)

if ("occurrenceStatus" %in% names(dt)) {
  dt <- dt %>% filter(toupper(occurrenceStatus) != "ABSENT")
}
counts$presence_filter <- nrow(dt)

name_col <- pick_first_existing(name_priority, names(dt))
if (is.na(name_col)) {
  stop("No usable name column found. Checked: ", paste(name_priority, collapse = ", "))
}

dt <- dt %>%
  mutate(species_std = .data[[name_col]]) %>%
  filter(!is.na(species_std), species_std != "")
counts$taxon_std_nonNA <- nrow(dt)

cc <- clean_coordinates(
  x       = dt,
  lon     = "decimalLongitude",
  lat     = "decimalLatitude",
  species = "species_std",
  tests   = cc_tests,
  value   = "clean"
)

dt_clean <- extract_cleaned_from_cc(cc, dt)
counts$coord_clean <- nrow(dt_clean)

if (counts$coord_clean == 0) {
  stop("No records left after coordinate cleaning. Check inputs/tests.")
}

# --------------------------- outputs ---------------------------
write.csv(dt_clean, outfile, row.names = FALSE, fileEncoding = "UTF-8")

log_df <- data.frame(
  step = names(counts),
  n    = as.integer(unlist(counts)),
  stringsAsFactors = FALSE
)
write.csv(log_df, logfile, row.names = FALSE, fileEncoding = "UTF-8")

message("Done.")
message("Input:  ", infile)
message("Output: ", outfile, " (rows = ", counts$coord_clean, ")")
message("Log:    ", logfile)
