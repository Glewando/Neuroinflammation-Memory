##########################################################################

#       Calculate the fold change for a transcript from qRt_PCR data     

# ======================= Procedure ======================================

## 1. calculate the delta CT for each of the baseline/control animals   
#       delta_ct = transcript ct (trnscrpt_ct) - house keeping transcript ct (hk_ct) 

## 2. calculate the mean baseline delta CT for the transcript   
#       ave_baseline_delta_ct = mean(delta_ct for each control animal)   

## 3. calculate the delta CT for the remaining animals
#       delta_ct = trnscrpt_ct - hk_ct

## 4. calculate the delta-delta CT for each animal
#       delta_delta_ct = delta_ct - ave_baseline_ct

## 5. calculate the fold change for each animal
#       fold_change <- 2^-delta_delta_ct 

# =================== fold-change function ================================

fold_change <- function(ave_baseline_ct, trnscrpt_ct, hk_ct){
    delta_ct <- trnscrpt_ct - hk_ct
    delta_delta_ct <- delta_ct - ave_baseline_ct
    2^-delta_delta_ct
}