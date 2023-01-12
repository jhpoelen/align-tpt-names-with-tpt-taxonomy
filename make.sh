#!/bin/bash
#
# take parasite tracker names from GloBI review and match them against tpt taxonomy

set -x

curl -L "https://raw.githubusercontent.com/globalbioticinteractions/globalbioticinteractions.github.io/423daefb80fbf46953c328ae98f65b56256b6e41/_data/parasitetracker.tsv"\
 | tee parasitetracker.tsv\
 | grep -v "globalbioticinteractions/cmnh-izc"\
 | mlr --tsvlite cut -f review_id\
 | tee parasitetracker_namespaces.tsv\
 | sed "s+^+https://depot.globalbioticinteractions.org/reviews/+"\
 | sed "s+$+/indexed-names.tsv.gz+g"\
 | tee parasitetracker_name_urls.txt\
 | tail -n+2\
 | xargs curl --silent -L\
 > names.tsv.gz

diff --side-by-side <(cat parasitetracker.tsv | tail -n+2 | cut -f10 | sort | uniq) <(cat names.tsv.gz | gunzip | cut -f7 | grep -v namespace | sort | uniq) > collections_vs_collections_with_indexed_names.txt

cat names.tsv.gz\
 | gunzip\
 | grep -v namespace\
 | cut -f1,2,7 | sort | uniq > names-collections.tsv 


echo 'nomer.schema.input=[{"column":0,"type":"externalId"},{"column": 1,"type":"name"}]'\
 > nomer.properties

echo 'nomer.schema.output=[{"column":0,"type":"externalId"},{"column": 1,"type":"name"}]'\
 >> nomer.properties

cat names-collections.tsv\
 | nomer append --properties nomer.properties tpt\
 > names-aligned.tsv

cat names-collections.tsv\
 | nomer replace --properties nomer.properties globi-correct\
 | nomer replace --properties nomer.properties gn-parse\
 | nomer append --properties nomer.properties tpt\
 > names-parsed-and-aligned.tsv

cat names-aligned.tsv | cut -f3 | sort | uniq -c | sort -k 2 > names-total.tsv
cat names-aligned.tsv | grep -v NONE | cut -f3 | sort | uniq -c | sort -k 2 > names-hits.tsv
cat names-aligned.tsv | grep  NONE | cut -f3 | sort | uniq -c | sort -k 2 > names-miss.tsv

paste names-total.tsv names-hits.tsv names-miss.tsv\
 | sed -E 's/[ ]+/ /g' | tr ' ' '\t'\
 > names.tsv


cat names-parsed-and-aligned.tsv | cut -f3 | sort | uniq -c | sort -k 2 > names-parsed-total.tsv
cat names-parsed-and-aligned.tsv | grep -v NONE | cut -f3 | sort | uniq -c | sort -k 2 > names-parsed-hits.tsv
cat names-parsed-and-aligned.tsv | grep  NONE | cut -f3 | sort | uniq -c | sort -k 2 > names-parsed-miss.tsv

paste names-parsed-total.tsv names-parsed-hits.tsv names-parsed-miss.tsv\
 | sed -E 's/[ ]+/ /g' | tr ' ' '\t'\
 > names-parsed.tsv
