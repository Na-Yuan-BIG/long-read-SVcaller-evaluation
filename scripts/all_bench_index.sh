3_ulont.lst  4_ont.lst  7_clr.lst  8_ccs.lst

for i in `cat 8_ccs.lst`;do 
cd $i/CCS/SVIM;
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tSVIM\t$n" > ../bench/num_stat
perl -lane 'chomp;print $_,"\tSVIM"' dup.col3.merge > ../bench/SVIM.dup.col4
perl -lane 'chomp;print $_,"\tSVIM"' del.col3.merge > ../bench/SVIM.del.col4
cd ../pbsv
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl all.dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl all.del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tpbsv\t$n" >> ../bench/num_stat
perl -lane 'chomp;print $_,"\tpbsv"' dup.col3.merge > ../bench/pbsv.dup.col4
perl -lane 'chomp;print $_,"\tpbsv"' del.col3.merge > ../bench/pbsv.del.col4
cd ../NanoVar
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tNanoVar\t$n" >> ../bench/num_stat
perl -lane 'chomp;print $_,"\tNanoVar"' dup.col3.merge > ../bench/NanoVar.dup.col4
perl -lane 'chomp;print $_,"\tNanoVar"' del.col3.merge > ../bench/NanoVar.del.col4
cd ../Sniffles
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tSniffles\t$n" >> ../bench/num_stat
perl -lane 'chomp;print $_,"\tSniffles"' dup.col3.merge > ../bench/Sniffles.dup.col4
perl -lane 'chomp;print $_,"\tSniffles"' del.col3.merge > ../bench/Sniffles.del.col4
cd ../Delly
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tDelly\t$n" >>  ../bench/num_stat
perl -lane 'chomp;print $_,"\tDelly"' dup.col3.merge  > ../bench/Delly.dup.col4
perl -lane 'chomp;print $_,"\tDelly"' del.col3.merge  > ../bench/Delly.del.col4
cd ../cuteSV
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  dup.col3 dup.col3.merge
perl /xtdisk/liufan_group/yuanna/cnv/NA12878/cnv_bench/merge.pl  del.col3 del.col3.merge
n_del=`wc del.col3.merge | perl -lane 'print $F[0]'`
n_dup=`wc dup.col3.merge | perl -lane 'print $F[0]'`
n=$[$n_del+$n_dup];
echo -e "$i\tcuteSV\t$n" >> ../bench/num_stat
perl -lane 'chomp;print $_,"\tcuteSV"' dup.col3.merge  > ../bench/cuteSV.dup.col4
perl -lane 'chomp;print $_,"\tcuteSV"' del.col3.merge  > ../bench/cuteSV.del.col4

cd  ../bench/
cat *.dup.col4 > all.dup
cat *.del.col4 > all.del
perl ../../../NA12878/cnv_bench/map_sort.pl all.dup all.dup.sort
perl ../../../NA12878/cnv_bench/map_sort.pl all.del all.del.sort
perl ../../../NA12878/cnv_bench/venn_merge.pl  all.dup.sort dup.merge
perl ../../../NA12878/cnv_bench/venn_merge.pl  all.del.sort del.merge



base_del=`perl -lane '%info=();for($i=3;$i<=$#F-1;$i+=4){$info{$F[$i]}=1 unless(defined $info{$F[$i]})};$len=keys%info;if($len>2){$n++};END{print "$n"}' del.merge`
base_dup=`perl -lane '%info=();for($i=3;$i<=$#F-1;$i+=4){$info{$F[$i]}=1 unless(defined $info{$F[$i]})};$len=keys%info;if($len>2){$n++};END{print "$n"}' dup.merge`
base_n=$[$base_del+$base_dup];
echo -e "SVIM\t$base_n\npbsv\t$base_n\nNanoVar\t$base_n\nSniffles\t$base_n\nDelly\t$base_n\ncuteSV\t$base_n" > base_stat

perl -lane '%info=();$p=0;$d=0;$c=0;$s1=0;$s2=0;$n1=0;for($i=3;$i<=$#F-1;$i+=4){$info{$F[$i]}=1 unless(defined $info{$F[$i]})};$len=keys%info;if($len>2){for($i=3;$i<=$#F-1;$i+=4){if($F[$i] eq "pbsv" && $p==0){$pb++;$p=1};if($F[$i] eq "Delly" && $d==0){$de++;$d=1};if($F[$i] eq "cuteSV" && $c==0 ){$cu++;$c=1};if($F[$i] eq "SVIM" &&$s1==0 ){$sv++;$s1=1};if($F[$i] eq "Sniffles" &&  $s2==0 ){$sn++;$s2=1};if($F[$i] eq "NanoVar" && $n1==0){$na++;$n1=1};}};END{print "SVIM\t$sv\npbsv\t$pb\nNanoVar\t$na\nSniffles\t$sn\nDelly\t$de\ncuteSV\t$cu"}' del.merge > del_stat
perl -lane '%info=();$p=0;$d=0;$c=0;$s1=0;$s2=0;$n1=0;for($i=3;$i<=$#F-1;$i+=4){$info{$F[$i]}=1 unless(defined $info{$F[$i]})};$len=keys%info;if($len>2){for($i=3;$i<=$#F-1;$i+=4){if($F[$i] eq "pbsv" && $p==0){$pb++;$p=1};if($F[$i] eq "Delly" && $d==0){$de++;$d=1};if($F[$i] eq "cuteSV" && $c==0 ){$cu++;$c=1};if($F[$i] eq "SVIM" &&$s1==0 ){$sv++;$s1=1};if($F[$i] eq "Sniffles" &&  $s2==0 ){$sn++;$s2=1};if($F[$i] eq "NanoVar" && $n1==0){$na++;$n1=1};}};END{print "SVIM\t$sv\npbsv\t$pb\nNanoVar\t$na\nSniffles\t$sn\nDelly\t$de\ncuteSV\t$cu"}' dup.merge > dup_stat

python  /pnas/pmod/yuann/bin/addColumns.py base_stat num_stat num_base 2
python  /pnas/pmod/yuann/bin/addColumns.py del_stat num_base num_base_del 2
python  /pnas/pmod/yuann/bin/addColumns.py dup_stat num_base_del num_base_del_dup 2
cat num_base_del_dup >> ../../../ccs_bench.stat

cd ../../../ 
done