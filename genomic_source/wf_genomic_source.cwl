#!/usr/bin/env cwl-runner
label: "Create Genomic Collection for Bacterial Pipeline"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: ScatterFeatureRequirement        

inputs:
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string
  
outputs:
  ids_out:
    type: File
    outputSource: prime_cache/ids_out
  gencoll_asn:
    type: File
    outputSource: gc_create/gencoll_asn
  seqid_list:
    #type: File[]
    type: File
    outputSource: gc_get_molecules/seqid_list
  stats_report:
    type: File
    outputSource: gc_asm_xml_description/stats_report
  asncache:
    type: Directory
    outputSource: gc_create/asncache
  
    
steps:
  prime_cache:
    run: prime_cache.cwl
    in:
      fasta: fasta
      submit_block_template: submit_block_template
      taxid: taxid
    out: [ids_out, asncache]

  gc_create:
    run: gc_create.cwl
    in:
      unplaced: prime_cache/ids_out
      asn_cache: prime_cache/asncache
      gc_assm_name: gc_assm_name

    out: [gencoll_asn, asncache]

  gc_get_molecules:
    run: gc_get_molecules.cwl
    #scatter: [ filter, outfile ]
    #scatterMethod: dotproduct
    in:
      gc_assembly: gc_create/gencoll_asn
      filter:
        #default: ["all", "all-no-organelle", "non-reference-no-organelle", "organelle", "reference-no-organelle"]
        default: "reference-no-organelle"
      outfile:
        #default: ["all.gi", "no_organelle.gi", "no_ref_no_organelle.gi", "organelle.gi", "ref_no_organelle.gi"]
        default: "ref_no_organelle.gi"
    out: [seqid_list]
      
  gc_asm_xml_description:
    run: gc_asm_xml_description.cwl
    in:
      asnfile: gc_create/gencoll_asn
    out: [stats_report]
    
