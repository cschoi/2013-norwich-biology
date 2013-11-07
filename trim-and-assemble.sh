#Make a working directory
cd
mkdir assembly2
cd assembly2

#Create a link in the data
ln -fs ~/mrnaseq-demo/*.gz .

normalize-by-median.py -p -k 20 -C 20 -N 4 -x 1e8  --savehash normC20k20.kh *.pe.qc.fq.gz

normalize-by-median.py -C 20 --loadhash normC20k20.kh --savehash normC20k20.kh *.se.qc.fq.gz

filter-abund.py -V normC20k20.kh *.keep

for i in *.pe.*.abundfilt;
do
   extract-paired-reads.py $i
done

for i in *.se.qc.fq.gz.keep.abundfilt
do
   pe_orphans=$(basename $i .se.qc.fq.gz.keep.abundfilt).pe.qc.fq.gz.keep.abundfilt.se
   newfile=$(basename $i .se.qc.fq.gz.keep.abundfilt).se.qc.keep.abundfilt.fq.gz
   cat $i $pe_orphans | gzip -c > $newfile
done

for i in *.abundfilt.pe
do
   newfile=$(basename $i .fq.gz.keep.abundfilt.pe).keep.abundfilt.fq
   mv $i $newfile
   gzip $newfile
done


cd ~/assembly2

for i in *.pe.qc.keep.abundfilt.fq.gz
do
    split-paired-reads.py $i
done

cat *.1 > left.fq
cat *.2 > right.fq

gunzip -c *.se.qc.keep.abundfilt.fq.gz >> left.fq
