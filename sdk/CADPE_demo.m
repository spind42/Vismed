% This script demoes the evaluation of an the outcome of a PE-detection
% algorithm

% The ability to load nrrd requires libteem to be installed.
% http://teem.sourceforge.net/index.html
% Please add the path to nrrdLoad in the following line
addpath('../teem');

addpath('sparse');

% clean the workspace
close all; clear all; clc;

%loads a sample test file with the output of the detections
dets = load('test.txt');

% sets a threshold for the detections
thres = 0.5;

% loads the reference standard. Please point to the appropriate folder.
% It must include the 20 files (00XXRefStd.nrrd) or the rs.mat with all
% reference standard images
rs = CADPE_loadReferenceStandard('Data/');

% evaluates the algorithm
[ss, fps,   ppv] = CADPE_evaluateDetections(dets, thres, rs)
