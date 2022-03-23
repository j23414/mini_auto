# mini_auto

With a focus on automation:

1. Pull new sequences from [VIPR Website](https://www.viprbrc.org/brc/vipr_genome_search.spg?method=ShowCleanSearch&decorator=flavi_zika):

  ![](imgs/zika_ViPR.png)

2. Download formatted fasta files:

  ![](imgs/zika_ViPR_download.png)

  You will have a `Genomic.fasta` file which will need to processed by `augur parse`.

2b. Alternatively, download the metadata and pull Genbanks manually:

  ![](imgs/zika_ViPR_results.png)

  You will have a `Results.tsv`.
  
  ```
  # List genbanks
  cat Results.tsv | awk -F'\t' '{print $4}' > zika_gb.ids
  bin/batchFetchGB.sh zika_gb.ids > zika.gb
  bin/procGenbank.pl zika.gb > zika.fasta
  ```

<!--
3. `Display Settings`, select any additional fields that may be useful
4. [x] Select all XX genomes
5. `Download`, [x] Tab Delimited - Displayed Columns Only
6. You will have a "Results.tsv"
-->

## New Website

ViPR seems to be migrating to a new website. I haven't found a length filter.

![](imgs/new_zikadb.png)

```
[[ -d data ]] || mkdir data
cd data
mv ~/Downloads Results.tsv .

# List genbanks
cat Results.tsv | awk -F'\t' '{print $4}' | head -n5
GenBank Accession
MT439645
KU501216
KX262887
MT377503
...

# Fetch genbanks

# Parse genbank into fasta& metadata

# If multi segmented, merge segments; 1 line = 1 sample

# Merge genbank and ViPr metadata (add indicator column for conflicts)

# Add rules/manual curation of conflicts

# Create a cached main metadata file, (only process/pull new Genbanks)

# Call clades per sample?

# Process/subsample for Nextstrain build
```
