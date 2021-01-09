#!/usr/bin/env nextflow

params.input_dir = false
params.output_dir = false
params.fastq_pattern = false
params.adapter_file = false
params.adapter_file1 = false

 adapter_file = file(params.adapter_file)
 adapter_file_1 = file(params.adapter_file1) 
 
if (params.input_dir) {
  input_dir = params.input_dir - ~/\/$/
  output_dir = params.output_dir - ~/\/$/
  fastq_pattern = params.fastq_pattern
  fastqs = input_dir + '/' + fastq_pattern
  Channel
    .fromFilePairs( fastqs )
    .ifEmpty { error "Cannot find any reads matching: ${fastqs}" }
    .set { raw_fastqs }
}

// pruning
process pruning { 
  memory '2 GB'
  conda 'cutadapt=3.1'  
  tag { pair_id }
  publishDir "${output_dir}",
    mode: 'copy'

  input:
  set pair_id, file(file_pair) from raw_fastqs
  file(adapter_file) from adapter_file
   
  output:
  set pair_id, file('pruned_fastqs/*.f*q.gz') into fastqs_to_prune

  """
  mkdir pruned_fastqs
  cutadapt -m 50 -j 2 -a file:${adapter_file} -A file:${adapter_file} -o pruned_fastqs/${file_pair[0]} -p pruned_fastqs/${file_pair[1]} ${file_pair[0]} ${file_pair[1]}

  """
}

// pruning2
process pruning2 {
  memory '2 GB'
  conda 'cutadapt=3.1'
  tag { pair_id }
  publishDir "${output_dir}",
    mode: 'copy'
  
  input:
  set pair_id, file(file_pair) from fastqs_to_prune
  file(adapter_file) from adapter_file_1

  output:
  set pair_id, file('pruned2_fastqs/*.f*q.gz') 

  """
  mkdir pruned2_fastqs
  cutadapt -m 50 -j 2 -a file:${adapter_file} -A file:${adapter_file} -o pruned2_fastqs/${file_pair[0]} -p pruned2_fastqs/${file_pair[1]} ${file_pair[0]} ${file_pair[1]}

  """
}
