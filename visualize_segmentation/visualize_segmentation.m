function eval = visualize_segmentation(img,varargin);
    scrsz = get(groot,'ScreenSize');
    fighandle = figure('Name','Segmentation','Position', [50 scrsz(4)/4 scrsz(3)/1.5 scrsz(4)/1.5])
    vis.handles.fig = fighandle;
    vis.nSlices = size(img,3);
    vis.nModalities = size(img,4);
    vis.modality = 1;
    vis.position = round((size(img,3)+1)/2);
    vis.isSeg = nargin>1;
    vis.isGT = nargin>2;
    vis.isRoi = nargin > 3;
    vis.origPermutation = [1 2 3];
    for i=1:vis.nModalities
        vis.img(:,:,:,i) = double(img(:,:,:,i)-min(min(min(img(:,:,:,i)))) );
        vis.img(:,:,:,i) = (vis.img(:,:,:,i)/max(max(max(vis.img(:,:,:,i)))) );
    end
    if vis.isSeg
        vis.seg = varargin{1};
    end
    if vis.isGT
        vis.gt = varargin{2};
    end
    if vis.isRoi
        vis.roi = varargin{3};
    else
        vis.roi = true(size(img(:,:,:,1)));
    end

    vis = init(vis)
    guidata(fighandle,vis);
  
    update(vis)
    uiwait(gcf)
    h = guidata(vis.handles.fig);
    close(h.handles.fig)
    eval = zeros(1,8);
    if vis.isSeg && vis.isGT
        [eval(1),eval(2),eval(3),eval(4),eval(5),eval(6),eval(7),eval(8)] = evalSegmentation(vis.seg,vis.gt,vis.roi);
    end
    
    % slider for slice position
    function positionSlider(hObject, eventdata);
        vis = guidata(gcbo);
        vis.position = round(get(hObject,'value'));
        update(vis);
    end
    % slider for changing te modality
    function modalitySlider(hObject, eventdata);
        vis = guidata(gcbo);
        vis.modality = round(get(hObject,'value'));
        update(vis);
    end
    % initialization of all components
    function vis = init(vis)
        width = 0.15;
        height = 0.05;
        xPos = 0.85;
        modalityStep = 1/(vis.nModalities-1);
        if modalityStep>1
            modalityStep = 1;
        end
        
        % slider for position change
        vis.handles.positionSlider = uicontrol('Parent',vis.handles.fig,'Style','slider', ...
              'Units','Normalized', ...
              'Position', [0 0 1 0.04], ...
              'HorizontalAlignment', 'center',...
              'User',[1 0 0],...
              'String','Position',...
              'visible','on', ...
              'Min',1,'Max',vis.nSlices,'Value',vis.position,...
              'SliderStep', [1/(vis.nSlices-1) 1/(vis.nSlices-1)],...
              'Callback',@positionSlider);
        
        % slider for modality changing
        if vis.nModalities > 1
            vis.handles.modalitySlider = uicontrol('Parent',vis.handles.fig,'Style','slider', ...
                  'Units','Normalized', ...
                  'Position', [0 0.04 0.02 0.95], ...
                  'HorizontalAlignment', 'center',...
                  'User',[1 0 0],...
                  'String','Modality',...
                  'visible','on', ...
                  'Min',1,'Max',vis.nModalities,'Value',1,...
                  'SliderStep', [modalityStep modalityStep],...
                  'Callback',@modalitySlider);
        end
        
        % button to close the window
        vis.handles.done = uicontrol('Parent',vis.handles.fig,'Style','push', ...
              'Units','Normalized', ...
              'Position', [xPos 0.1 width height], ...
              'HorizontalAlignment', 'center',...
              'User',[1 0 0],...
              'String','Done',...
              'visible','on', ...
              'Callback','uiresume(gcbf)');
         
        % panel for results
        vis.handles.results = uipanel('Parent',vis.handles.fig,'Title','Evaluation',...
             'Position',[.75 .5 .25 .49]);
         
        % table with results 
        rnames = {'Jaccard','Dice','Tanimoto','Accuracy','TPR','TNR','FPR','FNR'};
        cnames = {'Slice','Volume'};
        vis.handles.tableResults = uitable('Parent',vis.handles.results,...
            'Data',zeros(8,2),...
            'ColumnName',cnames, 'RowName',rnames);
        p1=get(vis.handles.tableResults,'Position');
        p2=get(vis.handles.tableResults,'Extent');
        posTmp = [p1(1:2) p2(3:4)];
        set(vis.handles.tableResults,'Position', posTmp);
        
        % axes 
        vis.handles.axes = axes('Parent',vis.handles.fig,'Position',[.03 .05 0.7 .94]);
        set(vis.handles.axes,'nextplot','replacechildren');
        set(vis.handles.fig,'colormap',gray);
        
        % button group for plane selection
        vis.handles.bg = uibuttongroup('Parent',vis.handles.fig,'Visible','off',...
                          'Position',[0.75 0.3 0.3 0.2]);
              
        vis.handles.r1 = uicontrol('parent',vis.handles.bg,'Style',...
                          'radiobutton',...
                          'String','plane 1',...
                          'Position',[0.1 0.1 0.1 0.1],...
                          'HandleVisibility','off');

        vis.handles.r2 = uicontrol('parent',vis.handles.bg,'Style','radiobutton',...
                          'String','plane 2',...
                          'Position',[0.1 0.1 0.1 0.1],...
                          'HandleVisibility','off');

        vis.handles.r3 = uicontrol('parent',vis.handles.bg,'Style','radiobutton',...
                          'String','plane 3',...
                          'Position',[0.1 0.1 0.1 0.1],...
                          'HandleVisibility','off');
        set(vis.handles.bg,'SelectionChangeFcn',@bselection);
        set(vis.handles.bg,'SelectedObject',[]);  % No selection
        set(vis.handles.bg,'Visible','on');
        
    end
    % changing the plane of visualization
    function bselection(hObject,callbackdata)
       display('povedlo se')
    end
    % update the visualization
    function update(vis)
        if vis.nSlices > 1
            vis.position = round(get(vis.handles.positionSlider,'value'));
        end
        if vis.nModalities > 1
            vis.modality = round(get(vis.handles.modalitySlider,'value'));
        end
        se = true(3);
        img = vis.img(:,:,vis.position,vis.modality)/max(vis.img(:));
        if vis.isSeg
            seg = bwmorph(vis.seg(:,:,vis.position),'remove',Inf);
            seg = imdilate(seg,se);
            img = imoverlay(img, seg,[1 0 0]);
        end
        if vis.isGT
            gt = bwmorph(vis.gt(:,:,vis.position),'remove',Inf);
            gt = imdilate(gt,se);
            img = imoverlay(img, gt,[0 0 1]);
        end
        imshow(img);
%         imagesc(img);
        axis([1 size(vis.img,2) 1 size(vis.img,1)])
        axis off
        hold on
        
        if vis.isSeg && vis.isGT
            [x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8)] = ...
                evalSegmentation(vis.seg(:,:,vis.position),vis.gt(:,:,vis.position),vis.roi(:,:,vis.position));
            [eval(1),eval(2),eval(3),eval(4),eval(5),eval(6),eval(7),eval(8)] = evalSegmentation(vis.seg,vis.gt,vis.roi); 
            Data=[x(:),eval(:)];
            set(vis.handles.tableResults,'data',Data);
        end
       
    end
end
