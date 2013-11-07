==================================
mRNAseq normalization and assembly
==================================

Digital normalization
---------------------

We're going to do `digital normalization
<http://ivory.idyll.org/blog/what-is-diginorm.html>`__ on the mRNAseq
data -- this is a research output from my lab.

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

Running the assembler
---------------------

Type::

   cd ~/assembly

   for i in *.pe.qc.keep.abundfilt.fq.gz
   do
       split-paired-reads.py $i
   done

   cat *.1 > left.fq
   cat *.2 > right.fq

   gunzip -c *.se.qc.keep.abundfilt.fq.gz >> left.fq

to extract the files into 'right' and 'left'; then run::

   export PATH=$PATH:~/software/bowtie:~/software/samtools

   ~/software/trinity/Trinity.pl --left left.fq --right right.fq --seqType fq -JM 1G

This will produce an output file ``trinity_out_dir/Trinity.fasta``.

Searching the resulting transcriptome
-------------------------------------

Do::

   cp trinity_out_dir/Trinity.fasta ./assembly.fa
   formatdb -i assembly.fa -o T -p F

and then let's search for a gene; NP_075023, a zinc transporter, is a
good one (because I know it's in the assembly :).

You can go grab it yourself (go to http://www.ncbi.nlm.nih.gov/protein/NP_075023.2, send to file) OR find it in the file browser under Training Files, NGS bootcamp biologists, NP_0705023.fasta.

Once you have the file, you can now BLAST it against your assembly::

   blastall -i NP_075023.fasta -d assembly.fa -p tblastn -o blast.txt -e 1e-12

And now do::

   less blast.txt

to take a look at the results.
