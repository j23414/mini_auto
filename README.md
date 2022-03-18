# mini_auto

With an eye for automation:

1. Visit [https://www.viprbrc.org/brc/vipr_genome_search.spg?method=ShowCleanSearch&decorator=flavi_zika](https://www.viprbrc.org/brc/vipr_genome_search.spg?method=ShowCleanSearch&decorator=flavi_zika)
2. [x] Genome; [x] Complete Genome Only; Click `Search`

![](imgs/zika_ViPR.png)

3. `Display Settings`, select any additional fields that may be useful
4. [x] Select all XX genomes
5. `Download`, [x] Tab Delimited - Displayed Columns Only
6. You will have a "Results.tsv"

![](imgs/zika_ViPR_results.png)

Or fetch fasta and take the `augur parse` route

![](imgs/zika_ViPR_download.png)

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
