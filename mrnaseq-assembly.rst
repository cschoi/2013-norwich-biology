==================================
mRNAseq normalization and assembly
==================================

Make a working directory and link in the data::

   cd
   mkdir assembly
   cd assembly
   ln -fs ~/mrnaseq-demo/*.gz .

Run digital normalization::

   normalize-by-median.py -p -k 20 -C 20 -N 4 -x 1e8  --savehash normC20k20.kh *.pe.qc.fq.gz

   normalize-by-median.py -C 20 --loadhash normC20k20.kh --savehash normC20k20.kh *.se.qc.fq.gz

Do error trimming::

   filter-abund.py -V normC20k20.kh *.keep

Extract remaining interleaved reads::

   for i in *.pe.*.abundfilt;
   do
      extract-paired-reads.py $i
   done

Combine and rename and make the data files friendly::

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

.. @@ download a protein sequence or two that I know
