cwlVersion: v1.0
label: "BLAST against rRNA db, scatter"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/bacterial_noncoding:pgap4.4

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: True
    
#gpx_qsubmit -affinity subject -asn-cache sequence_cache -max-batch-length 50000 -o jobs.xml -db ../../input/16S_rRNA/blastdb -ids sequences.seq_id
#gpx_qsubmit -asn-cache sequence_cache -o jobs.xml -ids sequences.seq_ids
baseCommand: gpx_qsubmit
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  seqids:
    type: File
    inputBinding:
      prefix: -ids
  output:
    type: string?
    default: jobs.xml
    inputBinding:
      prefix: -output
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
