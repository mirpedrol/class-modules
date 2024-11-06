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
	if ( params.treealign == "famsa/treealign" ) {
		FAMSA_TREEALIGN( ch_fasta, ch_tree )
		ch_out_alignment = ch_out_alignment.mix(FAMSA_TREEALIGN.out.alignment)
		ch_out_versions = ch_out_versions.mix(FAMSA_TREEALIGN.out.versions)
	}
	else if ( params.treealign == "magus/treealign" ) {
		MAGUS_TREEALIGN( ch_fasta, ch_tree )
		ch_out_alignment = ch_out_alignment.mix(MAGUS_TREEALIGN.out.alignment)
		ch_out_versions = ch_out_versions.mix(MAGUS_TREEALIGN.out.versions)
	}
	else if ( params.treealign == "clustalo/treealign" ) {
		CLUSTALO_TREEALIGN( ch_fasta, ch_tree )
		ch_out_alignment = ch_out_alignment.mix(CLUSTALO_TREEALIGN.out.alignment)
		ch_out_versions = ch_out_versions.mix(CLUSTALO_TREEALIGN.out.versions)
	}
	else if ( params.treealign == "tcoffee/treealign" ) {
		TCOFFEE_TREEALIGN( ch_fasta, ch_tree )
		ch_out_alignment = ch_out_alignment.mix(TCOFFEE_TREEALIGN.out.alignment)
		ch_out_versions = ch_out_versions.mix(TCOFFEE_TREEALIGN.out.versions)
	}


    emit:
	alignment = ch_out_alignment
	versions = ch_out_versions

}

