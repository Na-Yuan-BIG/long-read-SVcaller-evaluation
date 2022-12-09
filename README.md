# EValuation of long-read SV Callers 

Evaluation of the performances of structural variant callers on long reads from PacBio SMRT sequencing and Oxford Nanopore Technologies. This will include tests on public samples with several different type datasets from raw sequencing reads.

## 1. Download the raw sequencing data 

 **（1）Long-read datasets from 9 public samples include HG002, NA12878, CHM13 and CHM1 from EUR, HG00514, HX1 and HG005 from EAS, HG00733 from AMR and NA19240 from AFR.**

<table>
<tr>
<th>Sample</th>
<th>Data type</th>
<th>Sequcing reads</th>
</tr>


<tr>
<td rowspan="3">HG002</td>
<td>PacBio CCS</td>
<td>ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_CCS_15kb_20kb_chemistry2/reads/</td>
</tr>
<tr>
<td>PacBio CLR</td>
<td>ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_MtSinai_NIST/PacBio_fasta/</td>
</tr>
<tr>
<td>Ultra-long ONT</td>
<td>ftp:://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/UCSC_Ultralong_OxfordNanopore_Promethion/</td>
</tr>


<tr>
<td rowspan="3">NA12878</td>
<td>PacBio CCS</td>
<td>ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/HudsonAlpha_PacBio_CCS/PBmixSequel846_1_A01_PCCL_30hours_15kbV2PD_70pM_HumanHG001_CCS
;PBmixSequel846_2_B01_PCCM_30hours_21kbV2PD_70pM_HumanHG001_CCS</td>
</tr>
<tr>
<td>PacBio CLR</td>
<td>ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NA12878_PacBio_MtSinai/</td>
</tr>
<tr>
<td>Ultra-long ONT</td>
<td>http://s3.amazonaws.com/nanopore-human-wgs/rel7/rel_7.fastq.gz</td>
</tr>



<tr>
<td rowspan="3">CHM13</td>
<td>PacBio CCS</td>
<td>https://www.ncbi.nlm.nih.gov/bioproject/PRJNA530776</td>
</tr>
<tr>
<td>PacBio CLR</td>
<td>SRX818607, SRX825542, and SRX825575-SRX825579</td>
</tr>
<tr>
<td>Ultra-long ONT</td>
<td>https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/nanopore/rel8-guppy-5.0.7/reads.fastq.gz</td>
</tr>


<tr>
<td rowspan="3">HG00514;HG00733;NA19240</td>
<td>PacBio CCS</td>
<td>http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/working/</td>
</tr>
<tr>
<td>PacBio CLR</td>
<td>ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/hgsv_sv_discovery/smrt.sequence.index</td>
</tr>
<tr>
<td>ONT</td>
<td>ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/hgsv_sv_discovery/working/20181210_ONT_rebasecalled/</td>
</tr>


<tr>
<td >CHM1</td>
<td>PacBio CCS</td>
<td>SRX533609</td>
</tr>

<tr>
<td rowspan="2">HX1</td>
<td>PacBio CLR</td>
<td>SRX1424851</td>
</tr>
<tr>
<td>ONT</td>
<td>SRX5780136-SRX5780155</td>
</tr>



<tr>
<td >HG005</td>
<td>PacBio CCS</td>
<td>https://www.ncbi.nlm.nih.gov/bioproject/PRJNA540706</td>
</tr>


</table>


**（2）Generate data sets of the same sequencing depth with the maximum depth for all samples on different sequencing platform.**

#### For raw data (bas.h5 type) convert to fasta type and filter with minLength  and  minReadScore parameters:

```for i in ` cat pb/f_lst `;do python ../../software/pbh5tools/bin/bash5tools.py --minLength 1000 --readType subreads   --minReadScore 0.8 --outType fasta  --outFilePrefix ./fasta/"$i"   pb/"$i"*.bas.h5;done ```

#### For samples using seqtk tool:

```seq -s 11 -f 0.4268981  pb.fa.1k  > 20x.fa```

## 2. Alignment

The reference genome uses GRCh37/hg19. Each set of data was aligned to the reference genome using minimap2, pbmm2 and ngmlr methods respectively. samtools was used to sort mapping results to the BAM format.

  - [minimap2](https://github.com/lh3/minimap2) (2.20-r1061)

  - [ngmlr](https://github.com/philres/ngmlr) (0.2.7)

  - [pbmm2](https://github.com/PacificBiosciences/pbmm2) (1.7.0)

  - [samtools](https://github.com/samtools/samtools) (1.9)
  
  

#### For sample NA12878 20X PacBio CLR dataset :

```pbmm2 align $refdir/human.fa  $inputdir/20x.fa  $outputdir/ NA12878.bam  --sample NA12878 -j 8 -J 8 --sort --rg   '@RG\tID: NA12878'```

```minimap2  -ax map-pb --MD -Y  -t 20  $ refdir/human.fa   $inputdir/20x.fa  -o  $outputdir/ NA12878.sam```

```ngmlr --no-progress -x pacbio  -t 10 -r  $refdir/human.fa   -q $inputdir/20x.fa  -o $outputdir/NA12878.sam```

#### Sort mapping:

```samtools view -Sbh HX1.sam | samtools sort  -o HX1.bam```

```samtools index HX1.bam```


## 3.Long-read SV detection pipeline

### SV callers

  - [PBHoney](http://sourceforge.net/projects/pb-jelly/) (2.20-r1061)

  - [pbsv](https://github.com/PacificBiosciences/pbsv) (version 2.4.0)

  - [NanoSV](https://github.com/mroosmalen/nanosv) (version 1.2.4)

  - [NanoVar](https://github.com/cytham/nanovar) (version 1.4.1)

  - [Sniffles](https://github.com/fritzsedlazeck/Sniffles)  (version 1.0.12)

  - [SVIM](https://github.com/eldariont/svim)  (version 1.4.2)

  - [cuteSV](https://github.com/tjiangHIT/cuteSV)  (version 1.0.13)

  - [Delly](https://github.com/dellytools/delly)  (version 0.8.5)
  
  
#### pbsv

 ```pbsv discover  $inputdir/pbmm2/pbmm2.bam  ref.svsig.gz```

 ```pbsv call $refdir/human.fa   ref.svsig.gz  call.vcf```


#### cuteSV

 ```cuteSV   -s  3   -t 10  -l 1000 -S NA12878  $inputdir/minimap2/NA12878.bam  $refdir/human.fa  call.vcf  ./ ```

#### PBHoney

 ```Honey.py tails -o NA12878.tails -b 2 -z 2   $inputdir/ngmlr/NA12878.bam```

 ```Honey.py spots  -e 2 -E 2  --consensus None -o NA12878.spot --reference $refdir /human.fa  $inputdir/ngmlr/NA12878.bam ```

#### NanoSV

 ```NanoSV -t 10  -s  /software/sambamba  -b hg19.bed  -c config.ini  -o call.vcf $inputdir/minimap2/NA12878.bam ```

#### NanoVar

 ```nanovar  -t 10 -l 50  -x pacbio-ccs   $inputdir/minimap2/NA12878.bam  $refdir/human.fa  ./  --hsb  /software/nanovar/bin/hs-blastn ```

#### Delly

 ```delly_v0.9.1_linux_x86_64bit lr -y pb -g $inputdir/human.fa $inputdir/minimap2/NA12878.bam ```

#### Sniffles

 ```sniffles -m $inputdir/ngmlr/NA12878.bam  -t 10  -s 3 -q 5 -l 50 --genotype  -v call.vcf ```

#### SVIM

 ```svim alignment   --min_sv_size 50 ./   $inputdir/minimap2/NA12878.bam  $inputdir/human.fa ```




