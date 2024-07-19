if ( params.guidetree == "clustalo/guidetree" ) {
    include { CLUSTALO_GUIDETREE as GUIDETREE } from '../../../modules/mirpedrol/clustalo/guidetree/main'
} else if ( params.guidetree == "famsa/guidetree" ) {
    include { FAMSA_GUIDETREE    as GUIDETREE } from '../../../modules/mirpedrol/famsa/guidetree/main'
} else if ( params.guidetree == "magus/guidetree" ) {
    include { MAGUS_GUIDETREE    as GUIDETREE } from '../../../modules/mirpedrol/magus/guidetree/main'
}

workflow MSA_GUIDETREE {

    take:
    ch_fasta // channel: [ meta, fasta ]

    main:

    ch_versions = Channel.empty()

    GUIDETREE ( ch_fasta )
    ch_versions = ch_versions.mix(GUIDETREE.out.versions)

    emit:
    guidetree = GUIDETREE.out.tree // channel: [ meta, *.dnd ]
    versions  = ch_versions        // channel: [ versions.yml ]
}

