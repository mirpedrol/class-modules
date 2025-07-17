include { FAMSA_ALIGN } from '../../../modules/nf-core/famsa/align/main'
include { MAGUS_ALIGN } from '../../../modules/nf-core/magus/align/main'
include { CLUSTALO_ALIGN } from '../../../modules/nf-core/clustalo/align/main'
include { TCOFFEE_ALIGN } from '../../../modules/nf-core/tcoffee/align/main'


workflow MSA_TREEALIGN {

    take:
    ch_fasta
    ch_tree

    main:
    def ch_out_alignment = Channel.empty()
    def ch_out_versions = Channel.empty()

    ch_fasta
        .branch {
            meta, fasta, tool ->
                famsa_align: tool == "famsa_align"
                    return [ meta, fasta ]
                magus_align: tool == "magus_align"
                    return [ meta, fasta ]
                clustalo_align: tool == "clustalo_align"
                    return [ meta, fasta ]
                tcoffee_align: tool == "tcoffee_align"
                    return [ meta, fasta ]
        }
        .set { ch_fasta_branch }
    ch_tree
        .branch {
            meta, tree, tool ->
                famsa_align: tool == "famsa_align"
                    return [ meta, tree ]
                magus_align: tool == "magus_align"
                    return [ meta, tree ]
                clustalo_align: tool == "clustalo_align"
                    return [ meta, tree ]
                tcoffee_align: tool == "tcoffee_align"
                    return [ meta, tree ]
        }
        .set { ch_tree_branch }

    FAMSA_ALIGN( ch_fasta_branch.famsa_align, ch_tree_branch.famsa_align, [] )
    ch_out_alignment = ch_out_alignment.mix(FAMSA_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(FAMSA_ALIGN.out.versions)

    MAGUS_ALIGN( ch_fasta_branch.magus_align, ch_tree_branch.magus_align, [] )
    ch_out_alignment = ch_out_alignment.mix(MAGUS_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(MAGUS_ALIGN.out.versions)

    CLUSTALO_ALIGN( ch_fasta_branch.clustalo_align, ch_tree_branch.clustalo_align, [], [], [], [], [] )
    ch_out_alignment = ch_out_alignment.mix(CLUSTALO_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(CLUSTALO_ALIGN.out.versions)

    TCOFFEE_ALIGN( ch_fasta_branch.tcoffee_align, ch_tree_branch.tcoffee_align, [], [] )
    ch_out_alignment = ch_out_alignment.mix(TCOFFEE_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(TCOFFEE_ALIGN.out.versions)



    emit:
    alignment = ch_out_alignment
    versions = ch_out_versions

}

