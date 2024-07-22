process CLUSTALO_ALIGNMENT {
    tag "$meta.id"
    label 'None'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/clustalo:1.2.4--hfc679d8_2':
        'biocontainers/clustalo:1.2.4--hfc679d8_2' }"

    input:
    tuple val(meta), path(fasta)


    output:
    tuple val(meta), path("*.aln.gz"), emit: alignment
	path("versions.yml"), emit: versions
	

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    // TODO nf-class: Update the command to run the tool
    """
    clustalo \
        -t ${task.cpus} \
        $args \
        meta\ 
		fasta \
        meta\ 
		"*.aln.gz"\ 
		"versions.yml"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        clustalo: \$( clustalo --version )
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    // TODO nf-class: Update the output files to generate
    """
    touch meta\ 
		"*.aln.gz"\ 
		"versions.yml"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        clustalo: \$( clustalo --version )
    END_VERSIONS
    """
}
