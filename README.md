# Easy_GO_enrichment

This perl script is designed for (GO) enrichment analysis, using Fisher's exact test and FDR (False Discovery Rate) correction.

You need to install the Text::NSP::Measures::2D::Fisher::right module first: cpan -i Text::NSP::Measures::2D::Fisher::right

    Usage:
    -b <backgroud>   a text file containing the GO term for each gene.
                     example:    GO:0005524    AT3G54180
                                 GO:0006468    AT3G54180
                                 GO:0005515    AT3G54190
                                 GO:0006412    AT3G54210
    -i <gene_list>   input gene list, one gene per line.
                     example:    AT3G54180
                                 AT3G54180
                                 AT3G54190
                                 AT3G54210
    -r <0-1>         the threshold of RAW p-value for output. Mutually exclusive with -p.
    -p <0-1>         the threshold of adjusted p-value for output. Mutually exclusive with -r.
    -d <description> a text file containing the description for each GO term. (Optional)
                     example:    GO:0000001    mitochondrion inheritance
                                 GO:0000002    mitochondrial genome maintenance
                                 GO:0000003    reproduction
    -h               print this page

The example files can be found in the data folder.
