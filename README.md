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
