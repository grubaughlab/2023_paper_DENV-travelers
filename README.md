# Travel surveillance uncovers dengue virus dynamics and introductions in the Caribbean

This README contains information related to [this paper](https://www.medrxiv.org/content/10.1101/2023.11.11.23298412v1.full). 

Specifically:

- Information for [estimating local cases](https://github.com/grubaughlab/2023_paper_DENV-travelers/tree/main/R_estimating_local_cases), including input and output data as well as custom scripts in R
- [Alignments](https://github.com/grubaughlab/2023_paper_DENV-travelers/tree/main/alignments) for each serotype of dengue, used in the phylogeographic analysis
- [BEAST XML files](https://github.com/grubaughlab/2023_paper_DENV-travelers/tree/main/BEAST_XMLs) for recreating the phylogeographic analysis
    - NB these contain both "{serotype}_base" XMLs which are is the inference of the timetree and "{serotype}_dta" which perform the phylogegoprahic reconstruction on empirical tree sets obtained from the base analysis. Empirical tree sets are also included in this directory.
- [Jupyter notebook](https://github.com/grubaughlab/2023_paper_DENV-travelers/blob/main/Parse%20introductions.ipynb) containg python code for estimating introductions in the phylogeographic analysis