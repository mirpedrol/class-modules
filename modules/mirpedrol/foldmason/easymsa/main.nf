process FOLDMASON_EASYMSA {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/06/067e6389ab95497b753ba1deabaa6acbce25b99c8cfcf39c06d5c1af42fd7751/data':
        'community.wave.seqera.io/library/foldmason_pigz:88809eb5649534b0' }"

    input:
    tuple val(meta), path(pdbs)


    output:
    tuple val(meta), path("${prefix}.aln.gz"), emit: alignment
    path("versions.yml")                     , emit: versions


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    foldmason easy-msa \\
        ${pdbs} \\
        ${prefix} \\
        tmp \\
        $args \\
        --threads $task.cpus

    # Change name according to nf-class standard
    mv ${prefix}_3di.fa ${prefix}.aln

    pigz -p ${task.cpus} ${prefix}.aln

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        foldmason: \$( foldmason --version )
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"
    // TODO nf-class: Update the output files to generate
    """
    touch ${prefix}.aln
    pigz ${prefix}.aln

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        foldmason: \$( foldmason --version )
    END_VERSIONS
    """
}
