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
~ ~ ~ > * Log Setup
*/
log.info '''
dauerFrac
'''
log.info ""
log.info "Pipeline                                  = ${params.pipe}"
log.info ""

/*
~ ~ ~ > * Parameters setup
*/

params.help = null
params.debug = null
params.input = null
params.output = null
params.pipe = null

/*
~ ~ ~ > * WORKFLOW
*/
workflow {

    // get pipeline for cellprofiler     
    pipePath = Channel.fromPath(params.pipe)
    .view()

    // get output for cellprofiler
    outPath = Channel.fromPath(params.output)
    .view()

    // run cellproflier with pipeline and output
    runCP(pipePath, outPath)
    //view
}

/*
~ ~ ~ > * RUN CELLPROFILER
*/

process runCP {
    
    input:
        path pipePath
        path outPath

    output:
        stdout()

    """#!/bin/bash
        
        echo ${pipePath}

        # use cellprofielr 4.2.1 image
        #singularity exec -B /projects:/projects/ cellprofiler_4.2.1.sif \

        # run cellprofiler
        #cellprofiler -c -r -p ${pipePath} \
        #-g Metadata_Well=A01 \
        #-o ${outPath}

    """
}