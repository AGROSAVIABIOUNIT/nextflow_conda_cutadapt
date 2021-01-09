nextflow_workflows_dir=/path/to/your/nxf_base_directory
data_dir=/path/to/your/data_base_directory

nextflow run ${nextflow_workflows_dir}/cutadapt_prunning.nf \
--adapter_file ${nextflow_workflows_dir}/adapters.fas \
--adapter_file1 ${nextflow_workflows_dir}/adapters_1.fas \
--input_dir ${data_dir}/fastqs \
--fastq_pattern '*{_,R}{1,2}*.f*q.gz' \
--output_dir ${data_dir}/cutadapt_output \
-resume \
-ansi \
-profile standard \
-w ${data_dir}/cutadapt_output/work
