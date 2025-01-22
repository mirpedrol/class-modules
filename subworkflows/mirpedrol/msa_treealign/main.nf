include { FAMSA_TREEALIGN } from '../../../modules/mirpedrol/famsa/treealign/main'
include { MAGUS_TREEALIGN } from '../../../modules/mirpedrol/magus/treealign/main'
include { CLUSTALO_TREEALIGN } from '../../../modules/mirpedrol/clustalo/treealign/main'
include { TCOFFEE_TREEALIGN } from '../../../modules/mirpedrol/tcoffee/treealign/main'


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
                famsa_treealign: tool == "famsa_treealign"
                    return [ meta, fasta ]
                magus_treealign: tool == "magus_treealign"
                    return [ meta, fasta ]
                clustalo_treealign: tool == "clustalo_treealign"
                    return [ meta, fasta ]
                tcoffee_treealign: tool == "tcoffee_treealign"
                    return [ meta, fasta ]
        }
        .set { ch_fasta_branch }
    ch_tree
        .branch {
            meta, tree, tool ->
                famsa_treealign: tool == "famsa_treealign"
                    return [ meta, tree ]
                magus_treealign: tool == "magus_treealign"
                    return [ meta, tree ]
                clustalo_treealign: tool == "clustalo_treealign"
                    return [ meta, tree ]
                tcoffee_treealign: tool == "tcoffee_treealign"
                    return [ meta, tree ]
        }
        .set { ch_tree_branch }

    FAMSA_TREEALIGN( ch_fasta_branch.famsa_treealign, ch_tree_branch.famsa_treealign )
    ch_out_alignment = ch_out_alignment.mix(FAMSA_TREEALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(FAMSA_TREEALIGN.out.versions)

    MAGUS_TREEALIGN( ch_fasta_branch.magus_treealign, ch_tree_branch.magus_treealign )
    ch_out_alignment = ch_out_alignment.mix(MAGUS_TREEALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(MAGUS_TREEALIGN.out.versions)

    CLUSTALO_TREEALIGN( ch_fasta_branch.clustalo_treealign, ch_tree_branch.clustalo_treealign )
    ch_out_alignment = ch_out_alignment.mix(CLUSTALO_TREEALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(CLUSTALO_TREEALIGN.out.versions)

    TCOFFEE_TREEALIGN( ch_fasta_branch.tcoffee_treealign, ch_tree_branch.tcoffee_treealign )
    ch_out_alignment = ch_out_alignment.mix(TCOFFEE_TREEALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(TCOFFEE_TREEALIGN.out.versions)



    emit:
    alignment = ch_out_alignment
    versions = ch_out_versions

}

