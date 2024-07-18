process {{ component_name_underscore|upper }} {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        '{{ singularity_container if singularity_container else 'https://depot.galaxyproject.org/singularity/YOUR-TOOL-HERE' }}':
        '{{ docker_container if docker_container else 'biocontainers/YOUR-TOOL-HERE' }}' }"

    input:
    tuple val(meta) , path(fasta)

    output:
    tuple val(meta), path("*.aln.gz"), emit: alignment
    path "versions.yml"              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    {{ component }} \
        $args \
        -i $fasta \
        -o ${prefix}.aln.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        {{ component }}: \$( {{ component }} --version )
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.aln.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        {{ component }}: \$( {{ component }} --version )
    END_VERSIONS
    """
}
