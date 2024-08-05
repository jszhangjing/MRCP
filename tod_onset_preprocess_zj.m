function [trials] = tod_onset_preprocess_zj(vpath, bw,nord, isEOG, isEMG, isNonCausal,m_exp,run,movement_type)
 channel_num_select_from_bdf = [35 36 27 26 8 17 39 37]';%CP1 CP2 C1 Cz C2 FCz CP5 CP3


idle=5;
data.eeg = {};
data.event = {};
trials.data = [];
trials.rdata = [];
trials.treach = [];
trials.treturn = [];
trials.tdelay = [];
trials.trdelay = [];
trials.treturn = [];
trials.labels = [];
trials.info.sf = [];
trials.info.bdf = {};
trials.info.txt = {};
trials.info.num = [];
trials.baselineEEG = [];
if isEOG
    trials.dataeog = [];
    trials.baselineEOG = [];
    
end

if isEMG
    trials.dataemg = [];
    trials.baselineEMG = [];
end

nds = 1;
nds2= 1;
for f = 1:run
    [filename, pathname] = uigetfile({'*.bdf;*.edf';'*.*'},'Pick a recorded EEG data file','MultiSelect', 'on');
    EEG = readbdfdata(filename, pathname);
    data.eeg=EEG.data(channel_num_select_from_bdf,:);
    data.event=EEG.event;
    %取14个通道
    data.eeg = data.eeg';
    data.eeg = downsample(data.eeg,nds); 
    fs=EEG.srate/nds;
    [b,a] = butter(nord, bw/(fs/2));
   % fvtool(b,a)
    
    [b_low,a_low] = butter(nord, 95/(fs/2),'low');
    %fvtool(b_low,a_low)
    [b_hi,a_hi] = butter(nord, bw(1)/(fs/2),'high');
    
    trials.info.filter.order = nord;
    trials.info.filter.band = bw;
    
    data.eegcar = eegc2_car(eegc2_dc(data.eeg));
    if isNonCausal
        data.bpeeg = filtfilt(b_low,a_low,data.eegcar);
        data.bpeeg = downsample(data.bpeeg,nds2);
        
        fs = fs/nds2;
        [b,a] = butter(nord, bw/(fs/2));
        data.bpeeg = filtfilt(b,a,data.bpeeg);
        trials.info.filter.type = 'lp-bp';
    else
        data.bpeeg = filter(b_low,a_low,data.eegcar);
        data.bpeeg = downsample(data.bpeeg,nds2);
        fs = fs/nds2;
        [b,a] = butter(nord, bw/(fs/2));
        data.bpeeg = filter(b,a,data.bpeeg);
        trials.info.filter.type = 'butterfilter';
        %trials.info.filter.type = 'nofilt';         
    end
    trials.bsInter = [-1 2];%baseline [-1 2]
    trials.inter = [-3 2];
    %处理event
    a=struct2cell(data.event);
    c=char(a(1,:));
    raw(:,1)=str2num(c);
    raw(:,2)=(cell2mat(a(2,:)))';
    pos1=find(raw(:,1)==movement_type);
   modifiedpos1 = deleteFirstElementIfOne(pos1);
    trigger.go=raw(modifiedpos1,2);
    trigger.idle=raw(modifiedpos1-1,2);%求静息
    tstatus.baseline= ceil(trigger.idle/nds);
    tstatus.baseline= ceil(tstatus.baseline/nds2);
    tstatus.start= ceil(trigger.go/nds);
    tstatus.start= ceil(tstatus.start/nds+2);

     for i=1:length(tstatus.start)
            interval=[]; delay=[]; baseline_interval=[];
            interval = tstatus.start(i)+fs*(trials.inter(1)):tstatus.start(i)+fs*(trials.inter(2));
            trials.labels(end+1) = tstatus.start(i);
            trials.data(end+1, :, :) = data.bpeeg(interval,:);
            if isEOG
                trials.dataeog(end+1,:,:) = data.bpeog(interval,:);
            end
             delay = (tstatus.start(i)-tstatus.baseline(i))/fs-2;
             trials.tdelay(end+1) = delay;
            
            baseline_interval = tstatus.baseline(i) + fs*trials.bsInter(1):tstatus.baseline(i)+ fs*trials.bsInter(2);
            trials.baselineEEG(end+1,:,:) = data.bpeeg(baseline_interval,:);
     end
       clear raw;
end
    trials.info.sf = fs;
    trials.info.channels = size(trials.data,3);
    trials.type = m_exp;