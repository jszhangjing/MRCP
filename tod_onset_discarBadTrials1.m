function [trials, outTrial]=tod_onset_discarBadTrials(trials,m_pri)

% This function used for discarding bad trials using the following criteria
% 1) time of reach is less than 0.3s or longer than 1s. The average time of
% reach should be around 0.5s, if longer or shorter than this is considered
% a technical glitch and this trial should be discarded from further
% analysis.
%
% 2) tdelay is less than 2 s. This is a requirement to make the reaching
% trial closer to self-paced rather than highly dependent and locked to the
% audio target cue stimuli to reduce the effect of evoked potential.
%
% 3) discard trials with potentials outside the 95% percentile of overall
% distribution within the session. This is considered to be affected by
% environm
%
% INPUT: 
% trials - a structure consisting of:
% trials.data        - trial aligned with onset format: nTrials x timeSamples x channels (only 34 channels)
% trials.inter       - interval of this data (time 0 refers to onset)
% trials.baselineEEG - trials aligned with cue trigger: nTrials x timeSamples x channels (only 34 channels)
% trials.bsInter     - interval of this data (time 0 refers to cue trigger)
% trials.treach      - time of reaching
% trials.tdelay  - time from direction cue to onset
% trials.labels  - labels of direction
% trials.info    - miscellaneous info of recordings
% trials.info.sf - sampling rate
%
% Authors: Eileen Lew, CNBI, EPFL, 2011.

% glitchTrial = find(trials.treach <= 0.2 | trials.treach > 6);
% disp(['Trials with abnormal treach:' num2str(glitchTrial)]); 
% trials.data(glitchTrial,:,:) = [];
% trials.baselineEEG(glitchTrial,:,:) = [];
% trials.treach(glitchTrial)=[];
% trials.tdelay(glitchTrial)=[];
% trials.labels(glitchTrial)=[];

if strcmp(trials.type,'tod')
    trials.rdata(glitchTrial,:,:) = [];
    trials.trdelay(glitchTrial) = [];
end

nullTrial = find(trials.tdelay<2.5);%
disp(['Trials with tdelay<2.5:' num2str(nullTrial)]); 
trials.data(nullTrial,:,:) = [];
trials.baselineEEG(nullTrial,:,:) = [];
% trials.treach(nullTrial)=[];
trials.tdelay(nullTrial)=[];
trials.labels(nullTrial)=[];

if strcmp(trials.type,'tod')
    trials.rdata(nullTrial,:,:) = [];
    trials.trdelay(nullTrial) = [];
end

if strcmp(m_pri,'no')
    outTrial = findOutliers(trials.data,0.95);

    disp(['Outlier Trials:' num2str(outTrial)]); 
    trials.data(outTrial,:,:) = [];
%     trials.treach(outTrial)=[];
    trials.baselineEEG(outTrial,:,:) = [];
     trials.tdelay(outTrial)=[];
     trials.labels(outTrial)=[];

    if strcmp(trials.type,'tod')
        trials.rdata(outTrial,:,:) = [];
        trials.trdelay(outTrial) = [];
    end
else
    outTrial = [];
end

