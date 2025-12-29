# Easy_GO_enrichment

This perl script is designed for (GO) enrichment analysis, using Fisher's exact test and FDR (False Discovery Rate) correction.

You need to install the Text::NSP::Measures::2D::Fisher::right module first:
    
    cpan -i Text::NSP::Measures::2D::Fisher::right

Or you can install the module manually:

    tar -xf Text-NSP-1.31.tar.gz && cd Text-NSP-1.31
    perl Makefile.PL && make
    make install

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
   
    perl enrichment.pl -b data/background.GO -i data/input.txt -d data/GO.description.txt -p 0.05

    GO term Description     # within input  # within backgroud      Raw p-value     FDR adjusted p-value
    GO:0035735      intraciliary transport involved in cilium assembly      20      25      0       0
    GO:0061512      protein localization to cilium  20      25      0       0
    GO:0098590      plasma membrane region  28      36      0       0
    GO:0097712      vesicle targeting, trans-Golgi to periciliary membrane compartment      19      23      1.45439216225896e-14    3.51235707185538e-12
    GO:1905349      ciliary transition zone assembly        19      23      1.45439216225896e-14    2.8098856574843e-12
    GO:0030990      intraciliary transport particle 22      27      5.76205749780456e-14    9.27691257146535e-12
    GO:0035082      axoneme assembly        14      18      7.62541141341444e-11    1.05230677505119e-08
    GO:0005930      axoneme 12      14      7.90773224679242e-10    9.54858668800185e-08
    GO:0005874      microtubule     18      54      6.99146240901172e-09    7.50416965233924e-07
    GO:0005814      centriole       14      29      7.58024609748276e-09    7.32251773016834e-07
    GO:0005813      centrosome      12      27      1.76361372172806e-07    1.54877350471755e-05
    GO:0003341      cilium movement 8       11      1.29771160395364e-06    0.000104465784118268
    GO:0036064      ciliary basal body      7       9       4.46640983620128e-06    0.000331888607828495
    GO:0030992      intraciliary transport particle B       6       7       1.52448212502598e-05    0.00105189266626793
    GO:0005929      cilium  6       8       2.55833243428816e-05    0.00164756608768157
    GO:0060285      cilium-dependent cell motility  5       5       5.09433071873566e-05    0.00307570217143666
    GO:0032886      regulation of microtubule-based process 5       6       8.96761602773299e-05    0.00509571593105298
    GO:0060271      cilium assembly 5       7       0.000147615903377973    0.00792205348128457
    GO:0097539      ciliary transition fiber        4       4       0.0003093480649492      0.0157279068811014
    GO:0035869      ciliary transition zone 4       4       0.0003093480649492      0.0149415115370463
    GO:0070286      axonemal dynein complex assembly        4       4       0.0003093480649492      0.0142300109876632
    GO:0005856      cytoskeleton    7       22      0.000349902140715397    0.0153638849059579
    GO:0097546      ciliary base    4       5       0.000535602722598005    0.0224953143491162

