## dieroll_outcome: Figure that details average dieroll across treatments
rule dieroll_outcome:
    input:
        script = config["src_figures"] + "dieroll_outcome_treatment.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "dieroll_outcome_treatment.pdf"
    log:
        config["log"] + "figures/dieroll_outcome_treatment.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"

## dieroll_prop_six: Figure that details proportion of dieroll that are a six across treatments
rule dieroll_prop_six:
    input:
        script = config["src_figures"] + "dieroll_propsix_treatment.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "prop_sixes.pdf"
    log:
        config["log"] + "figures/dieroll_propsix_treatment.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"

## mech_descriptive: Figure that details role of descriptive mechanism across treatments
rule mech_descriptive:
    input:
        script = config["src_figures"] + "mechanism_descriptive.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "descriptive_treatment.pdf"
    log:
        config["log"] + "figures/mechanism_descriptive.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"

## mech_injunctive: Figure that details role of injunctive mechanism across treatments
rule mech_injunctive:
    input:
        script = config["src_figures"] + "mechanism_injunctive.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "injunctive_treatment.pdf"
    log:
        config["log"] + "figures/mechanism_injunctive.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"

## mech_justifiability: Figure that details role of justifiability mechanism across treatments
rule mech_justifiability:
    input:
        script = config["src_figures"] + "mechanism_justifiability.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "justifiability_treatment.pdf"
    log:
        config["log"] + "figures/mechanism_justifiability.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"

## mech_shared: Figure that details role of shared mechanism across treatments
rule mech_shared:
    input:
        script = config["src_figures"] + "mechanism_shared.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        fig = config["out_figures"] + "shared_treatment.pdf"
    log:
        config["log"] + "figures/mechanism_shared.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.fig} \
            > {log} {logAll}"
