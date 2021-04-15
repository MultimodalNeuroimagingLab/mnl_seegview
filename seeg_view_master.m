% Template for running SEEG view
%
% HH 2021

%% add paths, etc

% cd here
% add path to data subdirectory
% add path to SPM
% add path to gifti

%% rotate original matrix into acpc space
% pulls up GUI

kjm_SEEG_acpc_realign3

%% load acpc brain volume and transformation from original voxels -> acpc space

% Load .mat output from GUI
load('data/img_acpc.mat');

%% load and transform electrode positions into acpc space (mm)

elecFile = 'path/to/electrodes.tsv';

electrodes = readtable(elecFile, 'FileType','text','Delimiter','\t','TreatAsEmpty',{'N/A','n/a'});
locs = indexfix(data_raw.O_info, [electrodes.x, electrodes.y, electrodes.z], rot_mat_acpc);

% Load plot weights corresponding to each electrode loc
plot_wts = rand([size(locs, 1), 1]);

%% load and transform rendered brain into acpc space (mm)

cortex = gifti('path/to/cortex/segmentation.gii');
bv = indexfix(data_raw.O_info, cortex.vertices, rot_mat_acpc); % vertices in acpc pos
cortex.vertices = bv;

%%  plot 3D brain rendering with electrodes in acpc space, unweighted & weighted

figure; h1 = ieeg_RenderGifti(cortex); h1.FaceAlpha = 0.3;
el_add(locs, 'w');
text(locs(:,1), locs(:,2), locs(:,3), electrodes.name, 'Color', 'k', 'FontSize', 8);
loc_view(-90, 0);

figure; h2 = ieeg_RenderGifti(cortex); h2.FaceAlpha = 0.3;
plotCortexWeights(locs, plot_wts, 0.1);
loc_view(-90, 0);

%% threshold, clip sides of brain image, generate axis positions

bvol = data_acpc.brain_vol;
bmat = data_acpc.brain_info.mat; % transform acpc voxels -> position (mm)

% rescale signal to set 99pctile at 1 (acpc rotation could have removed some upper limits)
bvol = bvol/prctile(bvol(:), 99);

[bvol, bmat] = clipVol(bvol, bmat, 0.1); % remove edge slices with weak signal

[x, y, z] = getAxPos(bvol, bmat); % Get positions (mm) along x, y, z axes of brain volume

%% Plot slices of brain image with labelled electrodes

slicethickness = 8; % thickness of each plotted slice, in mm

[x_slice, y_slice, z_slice] = seegview_sliceplot(locs, bvol, x, y, z, slicethickness);
sv_label_add(locs, electrodes.name, x_slice);
sv_label_add(locs, electrodes.name, y_slice);
sv_label_add(locs, electrodes.name, z_slice);

%% (Alternatively) plot slices of brain image with weighted, unlabelled electrodes

[x_slice, y_slice, z_slice] = seegview_sliceplot(locs, bvol, x, y, z, slicethickness);
sv_weight_add(locs, plot_wts, x_slice, 0.1);
sv_weight_add(locs, plot_wts, y_slice, 0.1);
sv_weight_add(locs, plot_wts, z_slice, 0.1);
