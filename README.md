# class modules

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.10.3-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

![GitHub Actions Coda Linting](https://github.com/nf-core/modules/workflows/Code%20Linting/badge.svg)

> [!NOTE]
> THIS REPOSITORY IS A SUBSET OF THE [nf-core/modules](https://github.com/nf-core/modules) REPOSITORY

> [!WARNING]
> UNDER DEVELOPEMENT

A repository for hosting curated [Nextflow DSL2](https://www.nextflow.io/docs/latest/dsl2.html) subworkflow files and their associated documentation, and class description files.

## Table of contents

- [Using nf-core/tools](#using-nf-coretools)
- [Classes of modules](#classes-of-modules)
- [The class_module_index file](#the-class-module-index-file)

## Using nf-core/tools

The usual nf-core/tools can be used by specifying the appropriate repository.

```bash
nf-core modules --git-remote https://github.com/mirpedrol/class-modules.git <YOUR COMMAND>
```

## Classes of modules

A `class` is a way of grouping Nextflow DSL2 modules. All tools which share the same purpose (can be used to perform the same task) and share the same inputs and outputs, belong to the same class.

Essentially, a class is defined through a YAML file specifying the inputs and outputs of that class and some keywords, used to determine the purpose of that class. You can see examples of classes in the [classes directory](https://github.com/mirpedrol/class-modules/tree/main/classes).

The basic structure of a class YAML file is the following:

```myclass.yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/mirpedrol/class-modules/main/classes/class-schema.json
name: "myclass"
description: perform the task of this class
keywords:
    - task
    - topic
    - field
input:
    - - meta:
            type: map
            description: Groovy Map containing sample information
      - input1:
            type: file
            description: Input file for this class in FASTA format as an example
            pattern: "*.{fa,fasta}"
            ontologies:
                - edam: http://edamontology.org/format_1929
output:
    - channel1:
        - meta:
            type: map
            description: Groovy Map containing sample information
        - "*.txt"
            type: file
            description: The output file in TXT format of this class
            pattern: "*.txt"
```

## The `class_module_index` file

The file [`class_module_index.yml`](https://github.com/mirpedrol/class-modules/tree/main/class_module_index.yml) lists all classes and all nf-core/modules which belong to each of the classes.

This file can be edited to add new nf-core/modules to a class.
This information will then be used to update the existing class subworkflow,
or to generate a new class subworkflow.
