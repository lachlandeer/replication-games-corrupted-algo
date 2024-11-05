# Rules: help
#
# Contributors: @lachlandeer

## help_analysis  : prints help comments for Snakefile in analysis directory
rule help_analysis:
    input: config["rules"] + "analysis.smk"
    shell:
        "sed -n 's/^##//p' {input}"

## help_data_mgt  : prints help comments for Snakefile in data-management directory
rule help_data_mgt:
    input: config["rules"] + "data_mgt.smk"
    shell:
        "sed -n 's/^##//p' {input}"

## help_figures   : prints help comments for Snakefile in figures directory
rule help_figures:
    input: config["rules"] + "figures.smk"
    shell:
        "sed -n 's/^##//p' {input}"

## help_tables    : prints help comments for Snakefile in tables directory
rule help_tables:
    input: config["rules"] + "tables.smk"
    shell:
        "sed -n 's/^##//p' {input}"