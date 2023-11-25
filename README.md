
# Plot Figures

## Figure 3 - Dalorex vs Tascade scaling

    python3 plots/characterization.py -p 14 -m 0
    python3 plots/characterization.py -p 14 -m 8


## Figure 4 - Cascading

    python3 plots/characterization.py -p 21 -m 0
    python3 plots/characterization.py -p 21 -m 7
    python3 plots/characterization.py -p 21 -m 8


## Figure 5 - Proxy Size

    python3 plots/characterization.py -p 12 -m 0
    python3 plots/characterization.py -p 12 -m 7
    python3 plots/characterization.py -p 12 -m 8


## Figure 6 - Proxy Cache Pressure

    python3 plots/characterization.py -p 11 -m 0
    python3 plots/characterization.py -p 11 -m 7
    python3 plots/characterization.py -p 11 -m 8


## Figure 7 - Sync Characterization

    python3 plots/characterization.py -p 24 -m 0
    python3 plots/characterization.py -p 24 -m 7

## Figure 8 - Tascade with different Networks

    python3 plots/characterization.py -p 27 -m 0
    python3 plots/characterization.py -p 27 -m 7

## Figure 9 - Heatmap
    // Generate plots for configurations HEAT8 and HEAT64
    python3 gui/gui.py
    

## Figure 10 - Scaling plots

    python3 plots/characterization.py -p 6 -m 0
    python3 plots/characterization.py -p 6 -m 2


## ANIMATION FIGURE 9

### TASCADE

![heatmap_tascade](https://github.com/prisca71/tascade/assets/151456861/ad3c8bfd-4a73-4176-a381-417d00ffbc57)




### DALOREX

![heatmap_dalorex](https://github.com/prisca71/tascade/assets/151456861/9a77f5e9-d902-47a1-a01a-d589234dcaa1)



# Generate Runs


## Figure 3 - Dalorex vs Tascade scaling

    exp_tascade/run_exp_dlx_scale.sh 9 0 3


## Figure 4 - Cascading

    exp_tascade/run_exp_cascading.sh 9 0 2 128


## Figure 5 - Proxy Size

    exp_tascade/run_exp_proxy.sh 9 0 5 128


## Figure 6 - Proxy Cache Pressure

    exp_tascade/run_exp_pcache.sh 9 0 2 128


## Figure 7 - Sync Characterization

    exp_tascade/run_exp_sync.sh 9 0 1 128


## Figure 8 - Tascade with different Networks

    exp_tascade/run_exp_proxy_w_noc.sh 9 0 3 128

## Figure 9 - Heatmap

    exp_tascade/run_exp_heatmap.sh 5 0 1 64 Kron22


## Figure 10 - Scaling plots

    exp_tascade/run_exp_scaling_1m.sh 9 0 5

