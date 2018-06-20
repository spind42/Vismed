%ptk_main = PTKMain();

%V = dicomreadVolume('001');

%dataset = ptk_main.Load('001');
%dataset2 = ptk_main.Load('002');

%lobes = dataset.GetResult('PTKLeftAndRightLungs');

%vessels = dataset.GetResult('PTKVesselness');
%vessels2 = dataset2.GetResult('PTKVesselness');

%dilated = dataset.GetResult('PTKVesselnessDilated');

%PTKVisualiseIn3D([], vessels2, 2, true);


%PTKViewer(lobes);
%PTKViewer(vesselness);
%ct_image = dataset.GetResult('PTKLungROI');
%image_viewer = PTKViewer(ct_image);
%image_viewer.ViewerPanelHandle.Window = 1600;
%image_viewer.ViewerPanelHandle.Level = -600;
%image_viewer.ViewerPanelHandle.OverlayImage = lobes;


%smoothing_size_mm = 4;
%PTKVisualiseIn3D([], lobes, smoothing_size_mm, false);
%PTKVisualiseIn3D([], vesselness, smoothing_size_mm, false);





