process MTMALIGN_ALIGN {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-5bcf71dc66dac33d8e003c5e78043b80f5c7f269:8f0e486d46f7ab38892c1a8f78d2894a549d03b5-0':
        'biocontainers/mulled-v2-5bcf71dc66dac33d8e003c5e78043b80f5c7f269:8f0e486d46f7ab38892c1a8f78d2894a549d03b5-0' }"

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
    # decompress input files if required
    if ls ./*.pdb.gz 2&> /dev/null; then
        unpigz -d ./*.pdb.gz
    fi

    # construct input file for mtmalign
    ls *.pdb | sed s/\\ /\\n/ > input_list.txt

    mtm-align -i input_list.txt
    mv ./mTM_result/result.fasta ${prefix}.aln

    # Remove ".pdb" from the ids in the alignment file
    sed -i 's/\\.pdb//g' ${prefix}.aln

    # compress output file
    pigz -p ${task.cpus} ${prefix}.aln

    # mtm-align -v prints the wrong version 20180725, so extract it from the cosmetic output in the help message
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mTM-align: \$( mtm-align -h | grep -e "\\(Version [[:digit:]]*\\)" | grep -oe "[[:digit:]]*" )
        pigz: \$(echo \$(pigz --version 2>&1) | sed 's/^.*pigz\\w*//' ))
    END_VERSIONS
    """

    stub:
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.aln
    pigz ${prefix}.aln

    # mtm-align -v prints the wrong version 20180725, so extract it from the cosmetic output in the help message
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        mTM-align: \$( mtm-align -h | grep -e "\\(Version [[:digit:]]*\\)" | grep -oe "[[:digit:]]*" )
        pigz: \$(echo \$(pigz --version 2>&1) | sed 's/^.*pigz\\w*//' ))
    END_VERSIONS
    """
}
