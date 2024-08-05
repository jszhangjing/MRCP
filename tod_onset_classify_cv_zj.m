function  tod_onset_classify_cv_zj(trials,winsize,tSelect, tClassify, tres, featType)

%计算二分类的准确率，采用5折交叉验证的方法

if nargin < 7
   nFold = 5;
%    selected_chan = [5 10 17 24 25 30]; %use default channels from CP and C region
%    selected_chan = [13];%Cz
%    selected_chan = [2 3 6 7 8 12]; %CP1	CP2	C1	Cz	C2	FCz
      selected_chan = [1:1:8];  %CP3	CP1	CP2	CP4	C3	C1	Cz	C2	C4	FC3	FC1	FCz	FC2	FC4


end

fs=trials.info.sf;

data = trials.data(:,:,selected_chan);
bdata = trials.baselineEEG;

t = (1:size(data,2))/fs + trials.inter(1);

basewsize=tod_check_getWinFs(fs,winsize);
baseoffset = basewsize*2;%取0.5s~2s
wsize = basewsize/2;
cnt = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%
%base选择时间应该是1.0~2s
for i = 1:size(bdata,1)
        tmp = squeeze(bdata(i,:,:));

        base(cnt,:,:) = tmp(baseoffset+1:baseoffset+basewsize,selected_chan);
        cnt = cnt + 1;
end

ds = 1;%若是不降维，这里是1；降维是25.

for i=1:size(base,1)
    for chan=1:size(base,3)%可做
        switch lower(featType)
            case{'mean'}
                f_base(i,:,chan) = mean(base(i,1:ds:end,chan));
            case{'sig'}
                f_base(i,:,chan) = base(i,1:ds:end,chan);
            case{'phase'}
                f_base(i,:,chan) = atan2(imag(hilbert(base(i,1:ds:end,chan))),base(i,1:ds:end,chan));
            case{'amp'}
                f_base(i,:,chan) = sqrt(real(hilbert(base(i,1:ds:end,chan))).^2 + imag(hilbert(base(i,1:ds:end,chan))).^2); 
            case{'original'}
                f_base(i,:,chan) = base(i,1:ds:end,chan);
            case{'diff'}
                f_base(i,:,chan) = calculateFeatures(transpose(nthroot(base(i,1:ds:end,chan),3)));
        end
    end
end
f_base = reshape(f_base,size(f_base,1),size(f_base,2)*size(f_base,3));
d_base = ones(size(f_base,1),1);

pointer = find(t >= tSelect,1,'first'); %-0.75 with filtfilt
%f_onset = data(:,pointer-wsize+1:ds:pointer+wsize,:);
for i=1:size(data,1)
    for chan=1:size(data,3)
        switch lower(featType)
            case{'mean'}
                f_onset(i,:,chan) = mean(data(i,pointer-wsize+1:ds:pointer+wsize,chan));
            case{'sig'}
                f_onset(i,:,chan) = data(i,pointer-wsize+1:ds:pointer+wsize,chan);
            case{'phase'}
                f_onset(i,:,chan) = atan2(imag(hilbert(data(i,pointer-wsize+1:ds:pointer+wsize,chan))),data(i,pointer-wsize+1:ds:pointer+wsize,chan));
            case{'amp'}
                f_onset(i,:,chan) = sqrt(real(hilbert(data(i,pointer-wsize+1:ds:pointer+wsize,chan))).^2 + imag(hilbert(data(i,pointer-wsize+1:ds:pointer+wsize,chan))).^2);
            case{'original'}
                f_onset(i,:,chan) = data(i,pointer-wsize+1:ds:pointer+wsize,chan);
             case{'diff'}
                f_onset(i,:,chan) = calculateFeatures(transpose(nthroot(data(i,pointer-wsize+1:ds:pointer+wsize,chan),3)));
        end
    end
end
f_onset = reshape(f_onset,size(f_onset,1),size(f_onset,2)*size(f_onset,3));
d_onset = ones(size(f_onset,1),1)*2;

fvec_all=[[f_base;f_onset],[d_base;d_onset]];
save('fvec_all_diff.mat', 'fvec_all');

 