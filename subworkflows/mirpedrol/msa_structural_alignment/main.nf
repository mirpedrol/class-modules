include { FOLDMASON_EASYMSA } from '../../../modules/nf-core/foldmason/easymsa/main'
include { MTMALIGN_ALIGN } from '../../../modules/nf-core/mtmalign/align/main'


workflow MSA_STRUCTURAL_ALIGNMENT {

    take:
    ch_pdbs

    main:
    def ch_out_alignment = Channel.empty()
    def ch_out_versions = Channel.empty()

    ch_pdbs
        .branch {
            meta, pdbs, tool ->
                foldmason_easymsa: tool == "foldmason_easymsa"
                    return [ meta, pdbs ]
                mtmalign_align: tool == "mtmalign_align"
                    return [ meta, pdbs ]
        }
        .set { ch_pdbs_branch }

    FOLDMASON_EASYMSA( ch_pdbs_branch.foldmason_easymsa, [], [] )
    ch_out_alignment = ch_out_alignment.mix(FOLDMASON_EASYMSA.out.msa_aa)
    ch_out_versions = ch_out_versions.mix(FOLDMASON_EASYMSA.out.versions)

    MTMALIGN_ALIGN( ch_pdbs_branch.mtmalign_align, [] )
    ch_out_alignment = ch_out_alignment.mix(MTMALIGN_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(MTMALIGN_ALIGN.out.versions)



    emit:
    alignment = ch_out_alignment
    versions = ch_out_versions

}

