include { FAMSA_GUIDETREE } from '../../../modules/mirpedrol/famsa/guidetree/main'
include { MAGUS_GUIDETREE } from '../../../modules/mirpedrol/magus/guidetree/main'
include { CLUSTALO_GUIDETREE } from '../../../modules/mirpedrol/clustalo/guidetree/main'


workflow MSA_GUIDETREE {

    take:
    ch_fasta

    main:
    def ch_out_tree = Channel.empty()
    def ch_out_versions = Channel.empty()
    if ( params.msa_guidetree == "famsa/guidetree" ) {
        FAMSA_GUIDETREE( ch_fasta )
        ch_out_tree = ch_out_tree.mix(FAMSA_GUIDETREE.out.tree)
        ch_out_versions = ch_out_versions.mix(FAMSA_GUIDETREE.out.versions)
    }
    else if ( params.msa_guidetree == "magus/guidetree" ) {
        MAGUS_GUIDETREE( ch_fasta )
        ch_out_tree = ch_out_tree.mix(MAGUS_GUIDETREE.out.tree)
        ch_out_versions = ch_out_versions.mix(MAGUS_GUIDETREE.out.versions)
    }
    else if ( params.msa_guidetree == "clustalo/guidetree" ) {
        CLUSTALO_GUIDETREE( ch_fasta )
        ch_out_tree = ch_out_tree.mix(CLUSTALO_GUIDETREE.out.tree)
        ch_out_versions = ch_out_versions.mix(CLUSTALO_GUIDETREE.out.versions)
    }


    emit:
    tree = ch_out_tree
    versions = ch_out_versions

}

