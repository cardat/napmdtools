# napmdtools

CARDAT's NAPMD API

API and R interface developed by Grant Williamson and Ivan Hanigan

```r
# this is still in development so do the following
remove.packages("napmdtools")
library(devtools)
install_github("cardat/napmdtools", build_vignettes = TRUE, force = TRUE)
library(napmdtools)
vignette("napmd_ap_monitors_with_obs")
```


Acknowledgements:
---

The Australian National Air Pollution Monitor Database (NAPMD) was consolidated by the NHMRC Centre for Air pollution, Energy and Health Research (CAR) to standardise the national collection of data from all government air pollution monitors in Australia. All states and all pollutants for government regulatory monitoring data were collected from the 1990s to 2020. For more information see https://osf.io/jxd98/wiki/Metadata/

Centre for Air pollution, energy and health Research (2021): National Air Pollution Monitoring Database, derived from regulatory monitor data from NSW DPIE, Vic EPA, Qld DES, SA EPA, WA DEWR, Tas EPA, NT EPA, and ACT Health. The Centre for Air pollution, energy and health Research. (Dataset) DOI 10.17605/OSF.IO/JXD98