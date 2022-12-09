3_ulont.lst  4_ont.lst  7_clr.lst  8_ccs.lst

for i in `cat 7_clr.lst`;do 
cd $i/CLR/SVIM;
sh /xtdisk/liufan_group/yuanna/cnv/CHM13/CCS/cuteSV/t.sh SVIM $i
cd ../NanoVar
sh /xtdisk/liufan_group/yuanna/cnv/CHM13/CCS/cuteSV/t.sh NanoVar $i
cd ../Sniffles
sh /xtdisk/liufan_group/yuanna/cnv/CHM13/CCS/cuteSV/t.sh Sniffles $i
cd ../Delly
sh /xtdisk/liufan_group/yuanna/cnv/CHM13/CCS/cuteSV/t.sh Delly $i
cd ../cuteSV
sh /xtdisk/liufan_group/yuanna/cnv/CHM13/CCS/cuteSV/t.sh cuteSV $i
cd ../../../
done

