clear; close all; clc;
addpath(genpath('G:\MRCP_copy_0112\MatlabTools\'));
vpath = '.\';   
load('chanlocs64.mat');
run=4;
slow_go =10;
fast_go= 1;
channel_num_disp = [18 19 56 55 13 12 48 49 50 10 11 47 46 45]';%14ch show the correspongding to the chanlocs64--topoplot

 t_select = [  0 ];
trials = tod_onset_preprocess_zj(vpath,[0.1 1],2, 0, 0, 1,'venice', run, fast_go);
 datestr(now)
trials=tod_onset_discarBadTrials1(trials,'no');
figure;

tod_onset_classify_cv_zj(trials, 500, -0.5,[-2.5 1], 0.05, 'diff');

