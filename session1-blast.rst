===============================
Session 1: command line & BLAST
===============================

Welcome!
--------

`Welcome lecture <_static/norwich-lecture-welcome.pptx.pdf>`__

TODO:

1. start up your virtual machine
2. start up a browser
3. start up a terminal!
4. copying and pasting commands
5. copying common files around.

Copying & pasting commands
~~~~~~~~~~~~~~~~~~~~~~~~~~

Tips on copying and pasting commands:

* left mouse button to drag-select (copy) from this Web page;
* middle mouse button (push scroll wheel) to paste.

Try copy/pasting this into the terminal::

   echo 'hello, world'

Try copying multiple lines at once::

   ls
   echo 'this is my directory'

Done! You're now an expert!

BLAST
-----

`BLAST lecture <_static/norwich-lecture-blast.pptx.pdf>`__

Download and install some useful scripts::

    git clone https://github.com/ngs-docs/ngs-scripts ~/software/ngs-scripts

Create a working directory under the main user directory, and change
to that working directory::

   cd
   mkdir blast
   cd blast

('pwd' should show that you are in /home/student/blast).

Download the E. coli MG1655 protein data set::

   curl -O http://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

This grabs that URL and saves the contents of 'NC_000913.faa' to the local
disk.

Grab a Prokka-generated set of proteins (see e.g. http://2013-caltech-workshop.readthedocs.org/en/latest/prokka-annotation.html)::

   curl -O http://athyra.idyll.org/~t/ecoli0104.faa

Let's take a quick look at these files::

   head ecoli0104.faa
   head NC_000913.faa

These are FASTA protein files.

Format it for BLAST and run BLAST of the O104 protein set against the
MG1655 protein set::

   formatdb -i NC_000913.faa -o T -p T
   blastall -i ecoli0104.faa -d NC_000913.faa -p blastp -e 1e-12 -o 0104.x.NC -a 8

Look at the output file::

   head -20 0104.x.NC

Let's convert 'em to a CSV file::

   python ~/software/ngs-scripts/blast/blast-to-csv-with-names.py ecoli0104.faa NC_000913.faa 0104.x.NC > 0104.x.NC.csv

This creates a file '0104.x.NC.csv', which you can open in a spreadsheet
program like Excel or Google Docs/Spreadsheet.

Reciprocal BLAST calculation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Do the reciprocal BLAST, too::

   formatdb -i ecoli0104.faa -o T -p T
   blastall -i NC_000913.faa -d ecoli0104.faa -p blastp -e 1e-12 -o NC.x.0104 -a 8

Extract reciprocal best hit::

   python ~/software/ngs-scripts/blast/blast-to-ortho-csv.py ecoli0104.faa NC_000913.faa 0104.x.NC NC.x.0104 > ortho.csv

This generates a file 'ortho.csv', containing the ortholog assignments and
their annotations.

.. @@How can we look at this file
