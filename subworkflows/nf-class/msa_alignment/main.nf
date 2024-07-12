if ( params.aligner == "clustalo/align" ) {
    include { CLUSTALO_ALIGN as ALIGNER } from '../../../modules/nf-class/clustalo/align/main'
} else if ( params.aligner == "famsa/align" ) {
    include { FAMSA_ALIGN    as ALIGNER } from '../../../modules/nf-class/famsa/align/main'
} else if ( params.aligner == "kalign/align" ) {
    include { KALIGN_ALIGN   as ALIGNER } from '../../../modules/nf-class/kalign/align/main'
} else if ( params.aligner == "learnmsa/align" ) {
    include { LEARNMSA_ALIGN as ALIGNER } from '../../../modules/nf-class/learnmsa/align/main'
} else if ( params.aligner == "mafft" ) {
    include { MAFFT          as ALIGNER } from '../../../modules/nf-class/mafft/main'
} else if ( params.aligner == "magus/align" ) {
    include { MAGUS_ALIGN    as ALIGNER } from '../../../modules/nf-class/magus/align/main'
} else if ( params.aligner == "muscle5/super5" ) {
    include { MUSCLE5_SUPER5 as ALIGNER } from '../../../modules/nf-class/muscle5/super5/main'
} else if ( params.aligner == "tcoffee/align" ) {
    include { TCOFFEE_ALIGN  as ALIGNER } from '../../../modules/nf-class/tcoffee/align/main'
}

workflow MSA_ALIGNMENT {

    take:
    ch_fasta // channel: [ meta, fasta ]

    main:

    ch_versions = Channel.empty()

    ALIGNER ( ch_fasta )
    ch_versions = ch_versions.mix(ALIGNER.out.versions.first())

    emit:
    alignment = ALIGNER.out.alignment // channel: [ meta, *.aln.gz ]
    versions  = ch_versions           // channel: [ versions.yml ]
}

