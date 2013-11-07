Understanding Read Formats and Quality Controlling Data
=======================================================

:author: Chris Welcher and C. Titus Brown

Note: there are generic instructions for doing quality control at the
`khmer-protocols Web site
<https://khmer-protocols.readthedocs.org/en/latest>`__.  These should
work for most Illumina data sets, even those consisting of multiple
files.  Below, we've done a bit of a shorthand because we only have a
small data set to filter.

The fastq Format
````````````````

After spending weeks, nay, months of time on designing your study and
planning your bioinformatics goals (right?), you finally get the email
from you sequencing center: they have your data! You get a link to an
ftp server and some login information, and are presented with a list
of files. But what are these formats?

Most commonly, you'll get your data in fastq format. fastq is a really
simple way of representing sequence in plain text which is understood
by pretty much every piece of bioinformatics software. A fastq file
can contain anywhere from one to billions of sequences, and is usually
used for reads before they have been assembled. A faux example of the
format is::

    @read1
    +
    ATCGTAGCTAGCTAGCT
    +
    DH<F4CFDFH@FHIBBE
    
The first line is the name of the sequence; there is no set format for
this, though most of the big centers like the NCBI have set
standards. This is followed by a '+', a line break, and then the
sequence itself, which can be either nucleotide or protein.  Then we
have another line break, a '+', and a line break, followed by the
quality line.

The quality line is the part of the format which is not immediately
obvious. This line follows what is known as the phred format. Each
ASCII character corresponds to a base, and its integer mapping is used
in the equation :math:`P = 10^{-Q / 10}`, where :math:`Q` is the phred
score and :math:`P` is the probability that the base is incorrectly
called.

The counterpart to fastq is fasta, which is essentially fastq without
the quality score and a minor formatting change::

    >read1
    ATCGTAGGTAGGATATA
    
fasta is usually output by assembly programs, and can be used if data
has already been quality controlled and needs to be a more manageable
size. However, if you're not sure what preprocessing steps your data
has been through, but you have fasta instead of fastq, you'd be
well-off to make sure of what those steps were.


Getting the Data
````````````````

Now that you know a little about the format, let's look at some
data.

Copy the data in 'mrnaseq-demo' (under TrainingFiles, NGS bootcamp biologists)
into your home directory on your machine.  Be sure to copy and paste the
entire folder!

Now, let's look at it::

    cd ~/mrnaseq-demo
    ls

The data came from `this
<http://www.ncbi.nlm.nih.gov/pubmed/23731568>`__ study, if you're
interested.

To take a quick look at the files, use less::

    less 0Hour_ATCACG_L002_R1_001.pe.qc.fq.gz

Hit 'q' to quit less.

These reads are compressed with gzip to save some space.  In the .pe
files, they are interleaved paired FASTQ -- you can see the /1 and /2
-- output by the quality trimming step; and orphaned reads, in .se.

For example, in an interleaved file, you have::

    @SRR390202.1 M10_0139:1:2:18915:1321/1
    ATCAAGAAAGATTTTAACAGCATTGAC
    +
    ECCFFFDDHGHFDHJJJJIGIDIJJJJ
    @SRR390202.1 M10_0139:1:2:18915:1321/2
    GTTCATAGTGACAAGGTAATATTTGTC
    +
    FDFFFFHHGGIJIF?CIGJJGI@FEFH
    
Naturally, because this is a standard, almost every program has a
different way of doing it. So, be sure to double check the pairing
format in your data!

Assessing your Data with FastQC
```````````````````````````````

Before you go wildly charging at your data with trimmers and filters,
it's always a good idea to know what your data looks like ahead of
time. The program we will use for this is FastQC, which parses the
quality information from all the reads and produces handy charts and
statistics::

    mkdir ~/fastqc
    ~/software/FastQC/FastQC/fastqc 0Hour_ATCACG_L002_R1_001.* -o ~/fastqc

There is a folder for each of your sequence files, each of which
contains a file called ``fastqc_report.html``. Clicking on that file
will render the report in your browser.

Note, these data have already been processed with the trimming and filtering
steps here:

   https://khmer-protocols.readthedocs.org/en/v0.8.2/mrnaseq/

