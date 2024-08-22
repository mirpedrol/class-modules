if ( params.treealign == "famsa/treealign" ) {
    include { FAMSA_TREEALIGN as TREEALIGN } from '../../../modules/mirpedrol/famsa/treealign/main'
} else if ( params.treealign == "magus/treealign" ) {
    include { MAGUS_TREEALIGN as TREEALIGN } from '../../../modules/mirpedrol/magus/treealign/main'
} else if ( params.treealign == "clustalo/treealign" ) {
    include { CLUSTALO_TREEALIGN as TREEALIGN } from '../../../modules/mirpedrol/clustalo/treealign/main'
} else if ( params.treealign == "tcoffee/treealign" ) {
    include { TCOFFEE_TREEALIGN as TREEALIGN } from '../../../modules/mirpedrol/tcoffee/treealign/main'
} 

workflow MSA_TREEALIGN {

    take:
    ch_fasta
	ch_tree

    main:

    ch_versions = Channel.empty()

    TREEALIGN ( ch_fasta, ch_tree )
    ch_versions = ch_versions.mix(TREEALIGN.out.versions)

    emit:
	alignment = TREEALIGN.out.alignment
	versions = ch_versions

}

