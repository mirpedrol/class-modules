include { MAFFT } from '../../../modules/mirpedrol/mafft/main'
include { KALIGN_ALIGN } from '../../../modules/mirpedrol/kalign/align/main'
include { FAMSA_ALIGN } from '../../../modules/mirpedrol/famsa/align/main'
include { MUSCLE5_SUPER5 } from '../../../modules/mirpedrol/muscle5/super5/main'
include { MAGUS_ALIGN } from '../../../modules/mirpedrol/magus/align/main'
include { CLUSTALO_ALIGN } from '../../../modules/mirpedrol/clustalo/align/main'
include { TCOFFEE_ALIGN } from '../../../modules/mirpedrol/tcoffee/align/main'
include { LEARNMSA_ALIGN } from '../../../modules/mirpedrol/learnmsa/align/main'


workflow MSA_ALIGNMENT {

    take:
    ch_fasta

    main:
    def ch_out_alignment = Channel.empty()
    def ch_out_versions = Channel.empty()

    ch_fasta
        .branch {
            meta, fasta, tool ->
                mafft: tool == "mafft"
                    return [ meta, fasta ]
                kalign_align: tool == "kalign_align"
                    return [ meta, fasta ]
                famsa_align: tool == "famsa_align"
                    return [ meta, fasta ]
                muscle5_super5: tool == "muscle5_super5"
                    return [ meta, fasta ]
                magus_align: tool == "magus_align"
                    return [ meta, fasta ]
                clustalo_align: tool == "clustalo_align"
                    return [ meta, fasta ]
                tcoffee_align: tool == "tcoffee_align"
                    return [ meta, fasta ]
                learnmsa_align: tool == "learnmsa_align"
                    return [ meta, fasta ]
        }
        .set { ch_fasta_branch }

    MAFFT( ch_fasta_branch.mafft )
    ch_out_alignment = ch_out_alignment.mix(MAFFT.out.alignment)
    ch_out_versions = ch_out_versions.mix(MAFFT.out.versions)

    KALIGN_ALIGN( ch_fasta_branch.kalign_align )
    ch_out_alignment = ch_out_alignment.mix(KALIGN_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(KALIGN_ALIGN.out.versions)

    FAMSA_ALIGN( ch_fasta_branch.famsa_align )
    ch_out_alignment = ch_out_alignment.mix(FAMSA_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(FAMSA_ALIGN.out.versions)

    MUSCLE5_SUPER5( ch_fasta_branch.muscle5_super5 )
    ch_out_alignment = ch_out_alignment.mix(MUSCLE5_SUPER5.out.alignment)
    ch_out_versions = ch_out_versions.mix(MUSCLE5_SUPER5.out.versions)

    MAGUS_ALIGN( ch_fasta_branch.magus_align )
    ch_out_alignment = ch_out_alignment.mix(MAGUS_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(MAGUS_ALIGN.out.versions)

    CLUSTALO_ALIGN( ch_fasta_branch.clustalo_align )
    ch_out_alignment = ch_out_alignment.mix(CLUSTALO_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(CLUSTALO_ALIGN.out.versions)

    TCOFFEE_ALIGN( ch_fasta_branch.tcoffee_align )
    ch_out_alignment = ch_out_alignment.mix(TCOFFEE_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(TCOFFEE_ALIGN.out.versions)

    LEARNMSA_ALIGN( ch_fasta_branch.learnmsa_align )
    ch_out_alignment = ch_out_alignment.mix(LEARNMSA_ALIGN.out.alignment)
    ch_out_versions = ch_out_versions.mix(LEARNMSA_ALIGN.out.versions)



    emit:
    alignment = ch_out_alignment
    versions = ch_out_versions

}

