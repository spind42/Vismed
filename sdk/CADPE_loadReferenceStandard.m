function rs = CADPE_loadReferenceStandard(path)

%  CADPE_loadReferenceStandard(path) Computes the metrics for 
% the CADPE challenge for the given reference standard.
%
% In case several detection fall in the same clot, only one is taken into 
% account.
% 
% INPUT:
%   dets: matrix with the format
%         [nVolume, X, Y, Z, confidence]
%   threhsold: at which confidence score the detections should be computed
% OUTPUT:
%   ss: sensitivity: true positives/all positives
%   fps: average number of false positives per scan
%   ppv: positive predictive value
%
% 2013 German Gonzalez - M+Vision Consortium


rs = {};

if exist([path filesep 'rs.mat']) ~= 0
    try
        display(['Loading ' path filesep 'rs.mat']);
        load([path filesep 'rs.mat']);
    catch
       display(['The file ' path filesep 'rs.mat exists but can not be ' ...
           'read. Reference standard not loaded.']);
    end
else
    nClots = 0;
    for i = [1:20]
        display([' Loading reference standard ' num2str(i) ]);
        nm = sprintf('%s%s%04iRefStd.nrrd', path, filesep, i);
        try
            data = nrrdLoad(nm);
        catch
           display(['Error loading ' nm '. Reference standard not loaded']);
        end
        nClotsVolume = double(max(data(:)));
        nClots = nClots + nClotsVolume;
        rs.mask{i} = ndSparse(double(data)); 
        rs.nClots(i) = nClotsVolume;
    end
    rs.allClots = nClots;
    try
        display(['Saving ' path filesep 'rs.mat.']);
        save([path filesep 'rs.mat'], 'rs');
    catch
        display(['Error saving ' path filesep 'rs.mat.']);
    end
end
