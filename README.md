# EValuation of long-read SV Callers 

Evaluation of the performances of structural variant callers on long reads from PacBio SMRT sequencing and Oxford Nanopore Technologies. This will include tests on public samples with several different type datasets from raw sequencing reads.

## 1. Download the raw sequencing data 

### （1）Long-read datasets from 9 public samples include HG002, NA12878, CHM13 and CHM1 from EUR, HG00514, HX1 and HG005 from EAS, HG00733 from AMR and NA19240 from AFR.



### （2）Generate data sets of the same sequencing depth with the maximum depth for all samples on different sequencing platform 

* For raw data (bas.h5 type) convert to fasta type and filter with minLength  and  minReadScore parameters:

```for i in ` cat pb/f_lst `;do python ../../software/pbh5tools/bin/bash5tools.py --minLength 1000 --readType subreads   --minReadScore 0.8 --outType fasta  --outFilePrefix ./fasta/"$i"   pb/"$i"*.bas.h5;done ```

* For samples using seqtk tool:

```seq -s 11 -f 0.4268981  pb.fa.1k  > 20x.fa```

## 2. Alignment

The reference genome uses GRCh37/hg19. Each set of data was aligned to the reference genome using minimap2, pbmm2 and ngmlr methods respectively. samtools was used to sort mapping results to the BAM format.

  - [minimap2](https://github.com/lh3/minimap2) (2.20-r1061)

  - [ngmlr](https://github.com/philres/ngmlr) (0.2.7)

  - [pbmm2](https://github.com/PacificBiosciences/pbmm2) (1.7.0)

  - [samtools](https://github.com/samtools/samtools) (1.9)

* For sample NA12878 20X PacBio CLR dataset :

```pbmm2 align $refdir/human.fa  $inputdir/20x.fa  $outputdir/ NA12878.bam  --sample NA12878 -j 8 -J 8 --sort --rg   '@RG\tID: NA12878'```

```minimap2  -ax map-pb --MD -Y  -t 20  $ refdir/human.fa   $inputdir/20x.fa  -o  $outputdir/ NA12878.sam```

```ngmlr --no-progress -x pacbio  -t 10 -r  $refdir/human.fa   -q $inputdir/20x.fa  -o $outputdir/NA12878.sam```

* Sort mapping:

```samtools view -Sbh HX1.sam | samtools sort  -o HX1.bam```

```samtools index HX1.bam```


