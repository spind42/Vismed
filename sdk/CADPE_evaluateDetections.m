function [ss, fps, ppv] = CADPE_evaluateDetections(dets, threshold, rs)


%  CADPE_evaluateDetections(dets, threshold, rs) Computes the metrics for 
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

fpvol = zeros(1, length(rs.mask));
nClot = zeros(1, size(dets, 1));

for i = 1:size(dets,1)
    nClot(i) = rs.mask{dets(i,1)}(dets(i,2), dets(i,3), dets(i,4));    
end

%% Removes detections bellow the threshold
idxThreshElim   = find(dets(:,5) < threshold);
nClot(idxThreshElim) = -1;

%% See how many clots have been detected per volume
clotsDetected  = zeros(1, length(rs.mask));
falsePositives = zeros(1, length(rs.mask));
falsePositivesIdx = find(nClot==0);

for nV = 1:length(rs.mask)
   idxVol = find( dets(:,1) == nV);
   clotsLabelsInVol   = nClot(idxVol);
   % Gets the clots that have been detected
   clotsDetectedInVol = 0;
   for i = 1:rs.nClots(nV)
      if (numel(find(clotsLabelsInVol == i))~=0)
          clotsDetectedInVol = clotsDetectedInVol + 1;
      end
   end
   clotsDetected(nV) = clotsDetectedInVol;
   
   % Obtains the false positives in the volume   
   falsePositives(nV) = numel(intersect(falsePositivesIdx, idxVol));
end

ss  = sum(clotsDetected)/rs.allClots;
fps = sum(falsePositives)/length(rs.mask);
ppv = sum(clotsDetected)/(sum(falsePositives) + sum(clotsDetected));