# Aligning TPT Collection Names with TPT Taxonomy

date
12 January 2023

Aligning names across collections help to integrate data across collections.

Many tools are available to help extract taxonomic names in collections and align them against some existing taxonomy.

This repository is an example of how to align names using Elton, and Nomer using [make.sh](./make.sh), a [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) script. 

1. Elton extracts names from indexed interaction datasets
2. Nomer aligns names with Terrestrial Parasite Taxonomy
3. Generated with "total", "hits" and "misses"

[names.tsv](./names.tsv)

alternate workflow (with name scrubbing)

1. Elton extracts names from indexed interaction datasets
2. Nomer pre-processes names with name scrubbing and parsing  
3. Nomer aligns names with Terrestrial Parasite Taxonomy
4. Generated with "total", "hits" and "misses"

[names-parsed.tsv](./names-parsed.tsv)


Some collection have yet to index names.

[collections_vs_collections_with_indexed_names.txt](./collections_vs_collections_with_indexed_names.txt)
