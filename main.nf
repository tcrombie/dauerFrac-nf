#!/usr/bin/env nextflow

// Use DSL2
nextflow.preview.dsl=2

// QUEST nextflow message
if( !nextflow.version.matches('>20.0') ) {
    println "This workflow requires Nextflow version 20.0 or greater -- You are running version $nextflow.version"
    println "On QUEST, you can use `module load python/anaconda3.6; source activate /projects/b1059/software/conda_envs/nf20_env`"
    exit 1
}

//date = new Date().format( 'yyyyMMdd' )

/*
~ ~ ~ > * Parameters setup
*/

params.help = null
params.debug = null
params.input = null
params.output = null
params.pipe = null
params.test = "${workflow.projectDir}"

/*
~ ~ ~ > * Log Setup
*/
log.info '''
D A U E R F R A C - N F  P I P E L I N E
========================================
'''
log.info ""
log.info "Pipeline         = ${params.pipe}"
log.info "Output           = ${params.output}"
log.info "Project          = ${params.test}"
log.info ""

/*
~ ~ ~ > * WORKFLOW
*/

workflow {
    // get pipeline for cellprofiler     
    // pipePath = Channel.fromPath(params.pipe)
    //.view()

    // get output for cellprofiler could be first line of the .tsv file output by R script for groups - Dan Lu uses skip 1 with splitCsv maybe that would be helpful
    // outPath = Channel.fromPath(params.output)
    //.view()

    // define groups and file paths from hardcoded file - NEED TO CREATE THIS FILE in config_CP_input - R script would be easy
    groups = Channel.fromPath("/projects/b1059/projects/Tim/dauerFrac-nf/CP_test/groups.tsv")
        .splitCsv(header:true, sep: "\t")
        .map { row ->
                [row.group, file("${row.pipeline}"), file("${row.output}")]
            }
    //.view()

    // run cellproflier with pipeline and output
    // runCP(pipePath, outPath, groups)
    runCP(groups)
    //.view()
}

/*
~ ~ ~ > * CONFIGURE FILES FOR CELLPROFILER
*/

// process config_CP_input {

/*
~ ~ ~ > * RUN CELLPROFILER
*/

process runCP {
    input:
        tuple val(group), file(pipeline), file(output)

    output:
        stdout()

    """#!/bin/bash

        #echo ${group}
        #echo ${pipeline}
        #echo ${output}

        # use cellprofielr 4.2.1 image
        cellprofiler -c -r -p ${pipeline} \
        -g ${group} \
        -o ${output}

    """
}