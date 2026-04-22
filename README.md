# Patient Travel Time to Care  
### Kentucky Medicaid Managed Care Network Access Analysis (2018–2022)

This repository contains R scripts used to estimate patient travel distance and travel time to primary care providers using Kentucky Medicaid claims data and provider NPI practice address data.

The project was developed as part of a University of Kentucky research initiative evaluating healthcare access, provider network adequacy, and geographic barriers within Kentucky Medicaid Managed Care Organizations (MCOs). Findings supported biannual reporting on compliance with Kentucky Medicaid access standards.

---

## Project Background

Kentucky Medicaid requires participating Managed Care Organizations to maintain adequate provider networks under state regulations, including geographic access standards for primary care.

This project examined whether Medicaid members had reasonable geographic access to primary care providers by estimating:

- distance from patient ZIP code to provider practice location  
- estimated travel time to care  
- changes over time (2018–2022)  
- variation across provider classifications and plans  

The analysis supports monitoring of provider network adequacy and healthcare accessibility across Kentucky.

---

## Research Questions

This workflow was designed to answer questions such as:

- How far do Medicaid members need to travel for primary care?
- Did access improve between 2018 and 2022?
- Are some provider types more geographically available than others?
- Do observed travel patterns align with Kentucky access standards?

---

## Methodology

### Data Sources

- Kentucky Medicaid administrative claims data  
- National Provider Identifier (NPI) provider address files  
- ZIP code geographic centroids  
- Google Maps API geocoding services  

### Study Population

- Non-elderly Medicaid adults (ages 18–64)  
- Claims from plan years 2018–2022  
- Primary care related provider classifications including:

  - Family Medicine  
  - Internal Medicine  
  - Nurse Practitioner  
  - Preventive Medicine  
  - Clinic / Center

### Workflow

1. Extract provider NPIs from claims  
2. Join provider practice addresses  
3. Geocode provider locations  
4. Geocode patient ZIP code centroids  
5. Calculate patient-to-provider travel distance and travel duration  
6. Summarize results by provider classification and year  
7. Export dashboard-ready tables

---

## Repository Structure

```text
R/                  R analysis scripts
data/raw/           raw input data (not publicly included)
data/processed/     processed outputs
```

## Main Scripts

### `R/01_prepare_npi_locations.R`

Builds provider practice location file and geocodes addresses.

### `R/02_calculate_travel_time.R`

Joins patient ZIP locations to providers and calculates travel distance/time.

### `R/03_create_summary_table.R`

Creates final dashboard summary tables.

---

## Main Output

`data/processed/4.1 df_summary.csv`

Summary file containing:

- counts of claims / patients / NPIs  
- demographic distributions  
- travel distance statistics  
- travel duration statistics  
- year-over-year provider access trends  

---

## Key Findings (Project-Level)

Across the broader study, median distance to the nearest primary care provider declined between 2018 and 2022, suggesting improving geographic access over time.

Earlier project reporting found many Kentucky ZIP codes remained within the state’s benchmark access thresholds for primary care.

---

## Why This Project Matters

Healthcare access is not just insurance coverage—it also depends on whether care is realistically reachable.

This project demonstrates how claims data can be transformed into actionable access metrics for:

- Medicaid oversight  
- provider network monitoring  
- policy evaluation  
- rural health planning  
- healthcare analytics dashboards  

---

## Notes

- Raw Medicaid claims data are confidential and not included.  
- ZIP code centroid is used as a proxy for patient residence.  
- Provider billing/practice address may differ from actual treatment location.  
- Estimates depend on geocoding quality and routing assumptions.  

---

## Skills Demonstrated

- R data engineering  
- Healthcare claims analytics  
- Geospatial analysis  
- API-based geocoding  
- Dashboard summary table creation  
- Policy-focused research analytics  

---

## Author

Eugene Shin  
Healthcare Analytics | Medicaid Policy Research | Data Science
