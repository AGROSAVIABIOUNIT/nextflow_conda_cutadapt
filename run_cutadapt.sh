nextflow_workflows_dir=/home/nextflow_conda_cutadapt
data_dir=/home/path/to/data/parent/directory

nextflow run ${nextflow_workflows_dir}/cutadap_trimmo.nf \
--adapter_file ${nextflow_workflows_dir}/adapters.fas \
--input_dir ${data_dir}/fastqs \
--fastq_pattern '*.R{1,2}.f*q.gz' \
--output_dir ${data_dir}/cutadapt_trimmo_output \
-resume \
-ansi \
-profile standard \
-w ${data_dir}/cutadapt_trimmo_output/work
