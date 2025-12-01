include { CLUSTALO_GUIDETREE } from '../../../modules/nf-core/clustalo/guidetree/main'
include { FAMSA_GUIDETREE } from '../../../modules/nf-core/famsa/guidetree/main'
include { MAGUS_GUIDETREE } from '../../../modules/nf-core/magus/guidetree/main'
include { MAFFT_GUIDETREE } from '../../../modules/nf-core/mafft/guidetree/main'


workflow MSA_GUIDETREE {

    take:
    ch_fasta

    main:
    def ch_out_tree = Channel.empty()
    def ch_out_versions = Channel.empty()

    ch_fasta
        .branch {
            meta, fasta, tool ->
                clustalo_guidetree: tool == "clustalo_guidetree"
                    return [ meta, fasta ]
                famsa_guidetree: tool == "famsa_guidetree"
                    return [ meta, fasta ]
                magus_guidetree: tool == "magus_guidetree"
                    return [ meta, fasta ]
                mafft_guidetree: tool == "mafft_guidetree"
                    return [ meta, fasta ]
        }
        .set { ch_fasta_branch }

    CLUSTALO_GUIDETREE( ch_fasta_branch.clustalo_guidetree )
    ch_out_tree = ch_out_tree.mix(CLUSTALO_GUIDETREE.out.tree)
    ch_out_versions = ch_out_versions.mix(CLUSTALO_GUIDETREE.out.versions)

    FAMSA_GUIDETREE( ch_fasta_branch.famsa_guidetree )
    ch_out_tree = ch_out_tree.mix(FAMSA_GUIDETREE.out.tree)
    ch_out_versions = ch_out_versions.mix(FAMSA_GUIDETREE.out.versions)

    MAGUS_GUIDETREE( ch_fasta_branch.magus_guidetree )
    ch_out_tree = ch_out_tree.mix(MAGUS_GUIDETREE.out.tree)
    ch_out_versions = ch_out_versions.mix(MAGUS_GUIDETREE.out.versions)

    MAFFT_GUIDETREE( ch_fasta_branch.mafft_guidetree )
    ch_out_tree = ch_out_tree.mix(MAFFT_GUIDETREE.out.tree)
    ch_out_versions = ch_out_versions.mix(MAFFT_GUIDETREE.out.versions)



    emit:
    tree = ch_out_tree
    versions = ch_out_versions

}

