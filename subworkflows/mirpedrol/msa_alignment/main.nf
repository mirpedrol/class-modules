include { CLUSTALO_ALIGN } from '../../../modules/mirpedrol/clustalo/align/main'
include { FAMSA_ALIGN    } from '../../../modules/mirpedrol/famsa/align/main'
include { KALIGN_ALIGN   } from '../../../modules/mirpedrol/kalign/align/main'
include { LEARNMSA_ALIGN } from '../../../modules/mirpedrol/learnmsa/align/main'
include { MAFFT          } from '../../../modules/mirpedrol/mafft/main'
include { MAGUS_ALIGN    } from '../../../modules/mirpedrol/magus/align/main'
include { MUSCLE5_SUPER5 } from '../../../modules/mirpedrol/muscle5/super5/main'
include { TCOFFEE_ALIGN  } from '../../../modules/mirpedrol/tcoffee/align/main'

workflow MSA_ALIGNMENT {

    take:
    ch_fasta // channel: [ meta, fasta ]

    main:
    def ch_out_alignment = Channel.empty()
    def ch_versions = Channel.empty()

    if ( params.aligner == "clustalo/align" ) {
        CLUSTALO_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(CLUSTALO_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(CLUSTALO_ALIGN.out.versions.first())
    } else if ( params.aligner == "famsa/align" ) {
        FAMSA_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(FAMSA_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(FAMSA_ALIGN.out.versions.first())
    } else if ( params.aligner == "kalign/align" ) {
        KALIGN_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(KALIGN_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(KALIGN_ALIGN.out.versions.first())
    } else if ( params.aligner == "learnmsa/align" ) {
        LEARNMSA_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(LEARNMSA_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(LEARNMSA_ALIGN.out.versions.first())
    } else if ( params.aligner == "mafft" ) {
        MAFFT( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MAFFT.out.alignment)
        ch_versions = ch_versions.mix(MAFFT.out.versions.first())
    } else if ( params.aligner == "magus/align" ) {
        MAGUS_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MAGUS_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(MAGUS_ALIGN.out.versions.first())
    } else if ( params.aligner == "muscle5/super5" ) {
        MUSCLE5_SUPER5( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MUSCLE5_SUPER5.out.alignment)
        ch_versions = ch_versions.mix(MUSCLE5_SUPER5.out.versions.first())
    } else if ( params.aligner == "tcoffee/align" ) {
        TCOFFEE_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(TCOFFEE_ALIGN.out.alignment)
        ch_versions = ch_versions.mix(TCOFFEE_ALIGN.out.versions.first())
    }

    emit:
    alignment = ch_out_alignment // channel: [ meta, *.aln.gz ]
    versions  = ch_versions      // channel: [ versions.yml ]
}

