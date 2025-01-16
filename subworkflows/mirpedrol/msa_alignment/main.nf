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
    if ( params.msa_alignment == "mafft" ) {
        MAFFT( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MAFFT.out.alignment)
        ch_out_versions = ch_out_versions.mix(MAFFT.out.versions)
    }
    else if ( params.msa_alignment == "kalign/align" ) {
        KALIGN_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(KALIGN_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(KALIGN_ALIGN.out.versions)
    }
    else if ( params.msa_alignment == "famsa/align" ) {
        FAMSA_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(FAMSA_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(FAMSA_ALIGN.out.versions)
    }
    else if ( params.msa_alignment == "muscle5/super5" ) {
        MUSCLE5_SUPER5( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MUSCLE5_SUPER5.out.alignment)
        ch_out_versions = ch_out_versions.mix(MUSCLE5_SUPER5.out.versions)
    }
    else if ( params.msa_alignment == "magus/align" ) {
        MAGUS_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(MAGUS_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(MAGUS_ALIGN.out.versions)
    }
    else if ( params.msa_alignment == "clustalo/align" ) {
        CLUSTALO_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(CLUSTALO_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(CLUSTALO_ALIGN.out.versions)
    }
    else if ( params.msa_alignment == "tcoffee/align" ) {
        TCOFFEE_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(TCOFFEE_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(TCOFFEE_ALIGN.out.versions)
    }
    else if ( params.msa_alignment == "learnmsa/align" ) {
        LEARNMSA_ALIGN( ch_fasta )
        ch_out_alignment = ch_out_alignment.mix(LEARNMSA_ALIGN.out.alignment)
        ch_out_versions = ch_out_versions.mix(LEARNMSA_ALIGN.out.versions)
    }


    emit:
    alignment = ch_out_alignment
    versions = ch_out_versions

}

