# A Replication of "Corrupted by Algorithms?"

[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![lifecycle](https://img.shields.io/badge/version-0.1.0-red.svg)]()

## Project Overview

This project replicates the main tables and figures from Leib et al.'s article, ["Corrupted by Algorithms? How AI-generated and Human-written Advice Shape (Dis)honesty"](https://academic.oup.com/ej/article/134/658/766/7269206) published in the *Economic Journal*. The study investigates the influence of AI-generated versus human-written advice on dishonest behavior.

## Data Description

The dataset used in this replication is sourced from [Leib et al's OSF repostiory](https://osf.io/g3sw2/).

For detailed variable descriptions and data collection methodologies, refer to the `data/README.md` file.

## Code and Reproducibility

The analysis is conducted using R scripts organized in the `src/` directory. 

- `src/script1.R`: Description of analysis or figure/table generated.
- `src/script2.R`: Description of analysis or figure/table generated.
- ...

The project utilizes the `renv` package for R to manage dependencies, ensuring a reproducible environment. The `renv.lock` file captures the exact package versions used.

We use `Snakemake` to manage the workflow.

## Software and Dependencies

To replicate the analyses, ensure the following software is installed:

- **Python**: Version 3.6 or higher
- **Snakemake**: [Installation instructions](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- **R**: Version 4.2.0 or higher

R package dependencies are specified in the `renv.lock` file. To install them:

1. Open R in the project directory.
2. Run:
   ```r
   install.packages("renv")
   renv::restore()
   ```

OR use the Snakemake rules provided in `rules/renv.smk`.

## Instructions for Replication

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/lachlandeer/replication-games-corrupted-algo.git
   cd replication-games-corrupted-algo
   ```

2. **Set Up Python Environment**:
   - Install [Anaconda Python](https://www.anaconda.com/products/individual) or use the deadsnakes PPA for Python installation.
   - Create and activate a virtual environment:
     ```bash
     conda create -n replication-env python=3.8
     conda activate replication-env
     ```

3. **Install Snakemake**:
   ```bash
   pip3 install -r requirements.txt
   ```

4. **Set Up R Environment**:
   - Ensure R is installed.
   - Restore R package dependencies:
     ```r
     install.packages("renv")
     renv::restore()
     ```
     OR
     ```bash
     snakemake --cores 1 renv_install
     snakemake --cores 1 renv_consent
     snakemake --cores 1 renv_restore
     ```

5. **Execute the Analysis Pipeline**:
   - Run the Snakemake pipeline:
     ```bash
     snakemake all --cores 1
     ```

   This command will execute the analysis workflow as defined in the `Snakefile`, generating the replicated tables and figures.

## Citation and License

If you use or adapt this replication code, please cite the original study:

Margarita Leib, Nils Köbis, Rainer Michael Rilke, Marloes Hagens, Bernd Irlenbusch, Corrupted by Algorithms? How AI-generated and Human-written Advice Shape (Dis)honesty, The Economic Journal, Volume 134, Issue 658, February 2024, Pages 766–784, https://doi.org/10.1093/ej/uead056

Additionally, cite our replication report as:

[Lachlan Deer, Adithya  Krishna, Lyla Zhang]. (2025). "Replication Report:  Corrupted By Algorithms? How AI-generated And Human-written Advice Shape (Dis)Honesty". I4R Discussion Paper Series XXX

This project is licensed under the [MIT License](LICENSE).

---

*Note: Ensure all software installations and environment setups are compatible with your operating system. For any issues or questions, please open an issue in this repository.*
