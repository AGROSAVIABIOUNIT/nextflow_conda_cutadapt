
This process put together cutadapt and trimmomatic tools for cleaning reads with internal adapters contamination, it use nextflow to make process scalable

pre-requisites:

 conda ( pip install conda )

Create conda env
 
   conda create --name cutadapt_trimmo --file conda_env_nextflow_cutadapt_trimmo.txt

Run

Edit two first lines in (.sh) file with paths to nextflow_pipelines directory and data into fastqs directory (.fastq.gz) 

   sh file.sh

Have a look on your fastqs pattern (ej.'*{_,R}{1,2}.f*q.gz')

Now, you recovered your unvaluable files!!
