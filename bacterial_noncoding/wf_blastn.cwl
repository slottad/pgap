#!/usr/bin/env cwl-runner
label: "BLAST against rRNA db"
cwlVersion: v1.0
class: Workflow

#requirements:

inputs:
  asn_cache: Directory
  seqids: File
  blastdb_dir: Directory
  blastdb: string
  product_name: string
  outname: string
  
outputs:
  asncache:
    type: Directory
    outputSource: ribosomal_align2annot/asncache
  annotations:
    type: File
    outputSource: ribosomal_align2annot/annotations
    
steps:
  gpx_qsubmit:
    run: gpx_qsubmit_blastn.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
      blastdb_dir: blastdb_dir
      blastdb: blastdb
    out: [asncache, jobs]
  
  blastn_wnode:
    run: blastn_wnode.cwl
    in:
      asn_cache: gpx_qsubmit/asncache
      input_jobs: gpx_qsubmit/jobs
      blastdb_dir: blastdb_dir
    out: [asncache, outdir]

  gpx_make_outputs:
    run: gpx_make_outputs.cwl
    in:
      input_path: blastn_wnode/outdir
    out: [blast_align]

  align_merge:
    run: align_merge.cwl
    in:
      asn_cache: blastn_wnode/asncache
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      alignments: gpx_make_outputs/blast_align
    out: [asncache, aligns]

  ribosomal_align2annot:
    run: ribosomal_align2annot.cwl
    in:
      asn_cache: align_merge/asncache
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      product_name: product_name
      alignments: align_merge/aligns
      annotation: outname
    out: [asncache, annotations]
