# TE_detection
Codes for paper "A maximum-likelihood approach to estimating the insertion frequencies of transposable elements from population sequencing data".

1,There are two programs we used to detect the presence and absence of a TE insertion,respectively.

1.1, TE_pipeline (folder):
This is used to detect the number of reads supporting the presence of TE insertions, which is written by Heewook Lee and has been published before (Lee et al. 2014). There is a README file inside the "TE_pipeline" direction. The author put some explanation and how to run type of instructions for you. Read this and go over before you run the pipeline for other datasets.

1.2, TEscripts (folder):
This is an ad-hoc script that Wazim Mohammed Ismail had written using python to calculate the number of reads supporting each allele (wild-type vs. structural-variant) of the structural variation events reported by Grasper (https://github.com/COL-IU/GRASPER). 

Since, the break-points are specified by Grasper, you would need to run Grasper before running these scripts. Once you have the results from Grasper, you can run the script using the following command:

./indexMapSort.py  <reference>  <reads1> <reads2>  
teAllele.py <SV> ./sorted.bam  <outdir> 

where,
<reference> = reference file in fasta format
<reads1>, <reads2> = paired end reads in fastq format
<SV> = .SV file reported by Grasper(TE_pipeline)
./sorted.bam is produced by indexMapSort.py 
<outdir> = path of output by Grasper  

Pre-requisites:
1. Python 2.5 or above
2. BWA
3. Samtools

Output:
Same as Grasper (TE_pipeline) output (.SV file) but with additional two columns in the beginning. 
Column1: Number of reads supporting wild-type (i.e. No structural variation compared to the reference)
Column2: Number of reads supporting structural variation. 

Example:
./teAllele.py PA42.fasta PA2013-00112_12lanes_R1.paired.fastq PA2013-00112_12lanes_R2.paired.fastq total.insertion.1 output/

2, The simulation of reads is produced by simulaTE, which is a recently published software (https://sourceforge.net/projects/simulates/). The following is an example using one scaffold from daphnia reference genome and a daphnia TE library as input. With the produced reads, you can estimate effectiveness of TE detection algorithms.

<scaffold-1-noN.fa.masked>: clean daphnia scaffold_1 assembly masked by RepeatMasker 
<te-50.fa>: 50 TE sequences from published daphnia TE library (Jiang et al. 2017)

python /home/jiangxi/total-data/MBE/simulaTE/simulate/define-landscape_random-insertions-freq-range.py --chassis scaffold-1-noN.fa.masked --te-seqs te-50.fa --insert-count 100 --min-freq 1 --max-freq 1 --min-distance 500 --N 10 --output mylandscape.pgd

python /home/jiangxi/total-data/MBE/simulaTE/simulate/build-population-genome.py --pgd mylandscape.pgd --te-seqs te-50.fa --chassis scaffold-1-noN.fa.masked --output mylandscape.pg

python /home/jiangxi/total-data/MBE/simulaTE/simulate/read_pool-seq_illumina-PE.py --pg mylandscape.pg --read-length 100 --inner-distance 300 --std-dev 50 --error-rate 0.01 --reads 750000 --fastq1 reads_1.fastq --fastq2 reads_2.fastq 



2, The following several simply python or perl scripts were used to test the ML method, which were written by Xiaoqian Jiang.

2.1 simu.py:
This script is used to produce the expected genotype frequencies of TE insertions. Note to change the parameters in line 8-15 as needed.

2.2 p0p1.pl:
This script was used to estimate allele frequencies using the ML method. A typical use as follows, as well as the subsequent perl scripts:
perl p0p1.pl kap-reference.sum kap-reference.list > fraction.xxx
where the illustration of kap-reference.sum kap-reference.list files  has been demonstrated in the data file.

2.3 s1=s2=0.pl:
This script was used to produce the allele frequencies in neutral models.

2.4 s1=0.5s2.pl, s1=s2.pl and s1ors2.pl:
Thess scripts were used to test the selection power in 3 typical selection models. 

If you have any questions, please contact the authors.

