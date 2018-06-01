All the code for detecting TE and for the Maximum likelihood method in this paper have been stored in github( https://github.com/xiaoqian1984/TE_detection)

The dataset include:

1, Data used to simulate reads to test TE_pipeline:
<scaffold-1-noN.fa.masked>: clean daphnia scaffold_1 assembly masked by RepeatMasker 
<te-50.fa>: 50 TE sequences from published daphnia TE library (Jiang et al. 2017)

2, kap-reference.list, kap-non-reference.list:
List the details of searched TE insertions in each clone of KAP population.

The illustration of the column is:
name of TE**location of scaffold**(position/10KBp), clone_name position, observed genotype, reads supporing presence of TE, reads supporting absence of TE
PA42_1001_1933_2531_LTR_Copia**scaffold_156**0,	KAP-00004,	1933,	noinsert,	0,	8

3, kap-reference.sum, kap-non-reference.sum:
Summarized the total information in daphnia KAP population.

The illustration of the column is:
name of TE**location of scaffold**(position/10KBp), number of genotype(++), number of genotype(+-), number of genotype(--), total clone number, proportion of ++, proportion of +-, proportion of +-, theta

PA42_1001_1933_2531_LTR_Copia**scaffold_156**0	62	1	0	63	0.984126984126984	0.0158730158730159	0	0.35


The other used meta data has been published previously, if you have any problems in accessing the data, please contact the authors:
1, daphnia pulex reference assembly PA42 (Ye et al. 2017)
2, whole TE library of daphnia pulex (Jiang et al. 2017)
3, KAP population sequencing data (Lynch et al. 2016)
