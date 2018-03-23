cwlVersion: v1.0
label: "Search All HMMs I, gather"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/bacterial_annot:pgap4.4
    
#gpx_qdump -output hmm_hits.asn -unzip '*' -input-path output/
baseCommand: gpx_qdump
arguments: [ -unzip, '*' ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "hmm_hits.asn"
    inputBinding:
      prefix: -output

outputs:
  hmm_hits:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
