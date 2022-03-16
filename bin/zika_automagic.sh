#! /usr/bin/env bash

# Document script, move these into reusuable python functions later
CODEDIR=/Users/jenchang/github/j23414/mini_auto/bin

# Uncompress ViPR results
tar -xf Results.tar.gz
# Get list of genbanks
cat 36383448829-Results.tsv| awk -F'\t' '{print $4}' |grep -v "Gen" > zika_gb.ids
# Fetch raw Genbanks in batches of 100
${CODEDIR}/batchFetchGB.sh zika_gb.ids > zika.gb 

# Pull out metadata to match historical
# nextstrain remote download s3://nextstrain-data/files/zika/metadata.tsv.xz
# strain|virus|accession|date|region|country|division|city|db|segment|authors|url|title|journal|paper_url
# merge_metadata.sh old_metadata.tsv ViPR_metadata.tsv > merged_metadata.tsv
# merge_metadata.sh merged_metadata.tsv genbank_metadata.tsv > merged2_metadata.tsv
# Check "conflict" column manually, add new rules

# Pull out fasta to match historical
# nextstrain remote download s3://nextstrain-data/files/zika/sequences.fasta.xz
# >SG_071    #<= only strain name, no extra header annotations... I would have added genbanks, genotype but oh well.
${CODEDIR}/procGenbank.pl zika.gb > sequences.fasta
# xz -v sequences.fasta
# nextstrain remote upload ... sequences.fasta.xz


