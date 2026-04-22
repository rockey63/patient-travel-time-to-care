# Patient Travel Time to Care

This repository contains R scripts used to estimate patient travel distance and travel time to care using claims data and provider NPI practice address data.

Patient ZIP codes and provider practice addresses were geocoded, matched, and routed to estimate travel burden to care. Results were summarized by provider classification and year for dashboard reporting.

---

## Project Goal

Measure geographic access to care using:

- Patient ZIP code location
- Provider NPI practice address
- Estimated route distance
- Estimated route duration

---

## Repository Structure

```text
R/                  R analysis scripts
data/raw/           raw input data (not included publicly)
data/processed/     processed outputs
```

---

## Main Scripts

### `R/01_make_df_npi.R`

Creates provider location data from NPI practice addresses.

### `R/02_run_geo_family_2018.R`

Calculates patient ZIP to provider travel distance and travel time.

### `R/03_make_df_summary.R`

Creates dashboard-ready summary output.

---

## Main Output

`data/processed/4.1 df_summary.csv`

Summary table containing:

- counts  
- demographic distributions  
- travel distance summary  
- travel duration summary  

---

## Data Sources

Inputs expected:

### Claims file

Contains:

- provider NPI  
- patient ZIP  
- claim ID  
- demographic variables  

### NPI provider file

Contains:

- provider classification  
- provider practice address  
- specialization  

---

## Notes

- Raw claims data are not included in this public repository.  
- ZIP code location is an approximation of patient residence.  
- Provider practice address may differ from actual treatment location.  
- Route estimates depend on geocoding and routing services.  

---

## Author

Built for healthcare access and geospatial claims analysis in R.
