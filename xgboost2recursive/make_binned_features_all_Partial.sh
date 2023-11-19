#!/bin/sh

python binned_features.py '../processed/train_' 'RhoHV' 7 18 10 &
python binned_features.py '../processed/train_' 'Zdr' 7 18 10 & 
python binned_features.py '../processed/train_' 'LogWaterVolume' 7 18 10 &


