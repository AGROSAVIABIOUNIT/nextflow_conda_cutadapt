#!/usr/bin/env nextflow

params.input_dir = false
params.output_dir = false
params.fastq_pattern = false
params.adapter_file = false


 adapter_file = file(params.adapter_file)
 
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

##duplicate_adapters_channels
adapter_file.into {adapter_file_1; adapter_file_2}

// pruning
process pruning { 
  memory '2 GB'
  tag { pair_id }
  publishDir "${output_dir}", 
    mode: 'copy'

  input:
  set pair_id, file(file_pair) from raw_fastqs
  file(adapter_file) from adapter_file_1
   
  output:
  set pair_id, file('pruned_fastqs/*') into fastqs_to_trim

  """
  mkdir pruned_fastqs
  cutadapt -m 50 -j 2 -a file:${adapter_file} -A file:${adapter_file} -o pruned_fastqs/${file_pair[0]} -p pruned_fastqs/${file_pair[1]} ${file_pair[0]} ${file_pair[1]}

  """
}

// Trimming
process trimming {
  memory '4 GB'
  tag { pair_id }
  publishDir "${output_dir}",
   mode: 'copy'  

  input:
  set pair_id, file('pruned_fastqs/*') from fastqs_to_trim
  file(adapter_file) from adapter_file_2

  output:
  set pair_id, file('trimmed_fastqs/*.f*q.gz')

  """
  mkdir trimmed_fastqs
  trimmomatic PE -threads 1 -phred33 ${file_pair[0]} ${file_pair[1]} trimmed_fastqs/${file_pair[0]} trimmed_fastqs/${file_pair[1]} ILLUMINACLIP:adapter_file.fas:2:30:10 SLIDINGWINDOW:4:20 LEADING:25 TRAILING:25 MINLEN:50
  """
}
