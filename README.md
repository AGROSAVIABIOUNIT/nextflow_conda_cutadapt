
This process put together cutadapt and nextflow for scalable cleaning internal adapters contamination of raw reads

pre-requisites:

   conda ( pip3 install conda )

Create conda env
 
   conda create --name cutadapt --file conda_env_nextflow_cutadapt.txt

Run

Edit two first lines in (.sh) file with paths to nextflow_pipelines directory and data into fastqs directory (.fastq.gz) 

   sh file.sh

Have a look on your fastqs pattern (ej.'*{_,R}{1,2}.f*q.gz')

prunning -> adapter_cleaning
prunning2 -> polyAAA_cleaning


Now, you recovered your unvaluable files!!
