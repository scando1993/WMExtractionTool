function varargout = ACL (varargin)

addpath(fullfile(spm('dir'),'toolbox','ACL'));
cd (fullfile(spm('dir'),'toolbox','ACL'));
%% new
persistent PF FS WS PM TB  % GUI related constants
persistent ID            % Image display
persistent IP            % Input and results
persistent DGW           % Delete Graphics Window (if we created it)
global st                % Global for spm_orthviews

%%

%-Format arguments
%-----------------------------------------------------------------------
if nargin == 0, Action = 'Welcome'; else Action = varargin{1}; end
%=======================================================================
switch lower(Action), case 'welcome'             %-Welcome splash screen
    %=======================================================================
    % ACL('Welcome')
    %=======================================================================
    %
    % Create and initialise GUI for FieldMap toolbox
    %
    %=======================================================================
    % Unless specified, set visibility to on
    if nargin==2
        if ~strcmp(varargin{2},'off') && ~strcmp(varargin{2},'Off')
            visibility = 'On';
        else
            visibility = 'Off';
        end
    else
        visibility = 'On';
    end
    DGW = 0;
    IP = ACL('Initialise');
    % Get all default values (these may effect GUI)
    %        IP = ACL('Initialise');
    %
    % Since we are using persistent variables we better make sure
    % there is no-one else out there.
    %
    PM=[];
    TB=[];
    if ~isempty(PM)
        figure(PM);
        set(PM,'Visible',visibility);
        return
    end
    
    
    S0   = spm('WinSize','0',1);
    WS   = spm('WinScale');
    FS   = spm('FontSizes');
    PF   = spm_platform('fonts');
    rect = [100 100 510 520].*WS;
    
    PM = figure('IntegerHandle','off',...
        'Name','ACL Toolbox (version 1.0)',...
        'NumberTitle','off',...
        'Tag','ACL',...
        'Position',[S0(1),S0(2),0,0] + rect,...
        'Resize','off',...
        'Pointer','Arrow',...
        'Color',[1 1 1]*.8,...
        'MenuBar','none',...
        'DefaultTextFontName',PF.helvetica,...
        'DefaultTextFontSize',FS(10),...
        'DefaultUicontrolFontName',PF.helvetica,...
        'DefaultUicontrolFontSize',FS(10),...
        'HandleVisibility','on',...
        'Visible',visibility,...
        'DeleteFcn','ACL(''Quit'');');
    
    %% MENU
    
    h0  = uimenu(PM,...
        'Label',	'ACL_Tool',...
        'Separator',	'on',...
        'Tag',		'ACL_Tool',...
        'HandleVisibility','on');
    h1  = uimenu(h0,...
        'Label',	'Lesion segmentation',...
        'Separator',	'off',...
        'Tag',		'Lesion segmentation',...
        'HandleVisibility','on');
    h11  = uimenu(h1,...
        'Label',	'Modo Manual',...
        'Separator',	'off',...
        'Tag',		'pve lesion growing',...
        'CallBack','prop_lesTESIS_dos',...%'spm_jobman(''interactive'','''',''spm.tools.LST.lesiongrow'');',...
        'HandleVisibility','on');
    h12  = uimenu(h1,...
        'Label',	'Modo Auto',...
        'Separator',	'off',...
        'Tag',		'lesion growing',...
        'CallBack','spm_jobman(''interactive'','''',''spm.tools.LST.doit'');',...
        'HandleVisibility','on');
    h2  = uimenu(h0,...
        'Label',	'Utilities',...
        'Separator',	'off',...
        'Tag',		'Utilities',...
        'HandleVisibility','on');
    h21  = uimenu(h2,...
        'Label',	'Dicom import',...
        'Separator',	'off',...
        'Tag',		'lesion filling',...
        'CallBack','spm_jobman(''interactive'','''',''spm.tools.LST.lesfill'');',...
        'HandleVisibility','on');
    h22  = uimenu(h2,...
        'Label',	'Print Volume',...
        'Separator',	'off',...
        'Tag',		'lesion thresholding',...
        'CallBack','spm_jobman(''interactive'','''',''spm.tools.LST.lesthresh'');',...
        'HandleVisibility','on');
    h23  = uimenu(h2,...
        'Label',	'Reorient images',...
        'Separator',	'off',...
        'Tag',		'Total lesion volume',...
        'CallBack','spm_jobman(''interactive'','''',''spm.tools.LST.lesvolume'');',...
        'HandleVisibility','on');
    h24  = uimenu(h2,...
        'Label',	'Help',...
        'Separator',	'off',...
        'Tag',		'Total lesion volume',...
        'CallBack','ACL(''Help'');',...
        'HandleVisibility','on');
    
    uimenu(h0,'Label','Quit','Callback','ACL(''Quit'');',...
        'Separator','on','Accelerator','Q');
    
    
    %% cuadros
    
    uicontrol(PM,'Style','Frame','BackgroundColor',spm('Colour'),...
        'Position',[10 10 490 510].*WS);
    uicontrol(PM,'Style','Text','String','Prometo - Viejos Sabios',...
        'Position',[21 52 300 010].*WS,...
        'ForegroundColor','k','BackgroundColor',spm('Colour'),...
        'FontName',PF.times,'FontAngle','Italic','FontSize',5,'HorizontalAlignment','left');
    uicontrol(PM,'Style','Text','String','Neuroimaging & BioEngineering Laboratory',...
        'Position',[21 42 300 010].*WS,...
        'ForegroundColor','k','BackgroundColor',spm('Colour'),...
        'FontName',PF.times,'FontAngle','Italic','FontSize',5,'HorizontalAlignment','left');
    uicontrol(PM,'Style','Text','String','FIEC - ESPOL, Ecuador',...
        'Position',[21 32 300 010].*WS,...
        'ForegroundColor','k','BackgroundColor',spm('Colour'),...
        'FontName',PF.times,'FontAngle','Italic','FontSize',5,'HorizontalAlignment','left');
    %  uicontrol(PM,'Style','Text','String','ACL',...
    %             'Position',[183 188 115 115].*WS,...
    %             'ForegroundColor','k','BackgroundColor',spm('Colour'),...
    %                 'FontName',PF.times,'FontAngle','Italic','FontSize',35);
    % uicontrol(PM,'Style','Frame','BackgroundColor',spm('Colour'),...
    %     'Position',[100 480 300 020].*WS);
    
    %% saleccion del modo con radio-button
    uicontrol(PM,'Style','radiobutton',...
        'String','AUTO',...
        'Position',[30 450 64 022].*WS,...
        'ToolTipString','Select mode auto',...
        'CallBack','ACL(''InputFormat'');',...
        'UserData',1,...
        'Tag','IFormat');
    uicontrol(PM,'Style','radiobutton',...
        'String','MANUAL',...
        'Position',[96 450 74 022].*WS,...
        'ToolTipString','Select mode auto',...
        'CallBack','ACL(''InputFormat'');',...
        'UserData',2,...
        'Tag','IFormat');
    
    %% botones basicos
    uicontrol(PM,'String','Help',...
        'Position',[183 380 59 059].*WS,...
        'ToolTipString','Help',...
        'CallBack','ACL(''Help'');',...
        'ForegroundColor','b',...
        'Tag','Help','FontSize',7);
    uicontrol(PM,'String','Quit',...
        'Position',[237 380 59 059].*WS,...
        'Enable','On',...
        'ToolTipString','Exit toolbox',...
        'CallBack','ACL(''Quit'');',...
        'ForegroundColor','r',...
        'Tag','Quit','FontSize',7);
    %% botones cargar estudio
    uicontrol(PM,'String','Load',...
        'Position',[183 434 114 059].*WS,...
        'ToolTipString','Load folders of Study',...
        'CallBack','ACL(''Load'');',...
        'Tag','load','FontSize',7);
    %% botones ejecutar
    
    uicontrol(PM,'String','Organize',...
        'Position',[21 326 59 059].*WS,...
        'ToolTipString','Organize folders of Study',...
        'CallBack','ACL(''org_study'');',...
        'Tag','Org_study','FontSize',7);
    
    uicontrol(PM,'String','Classify',...
        'Position',[75 326 59 059].*WS,...
        'ToolTipString','classify folders of Study',...
        'CallBack','ACL(''creategroups'');',...
        'Tag','clasificate','FontSize',7);
    
    uicontrol(PM,'String','Dicom',...
        'Position',[129 326 59 059].*WS,...
        'ToolTipString','clean folders of Study',...
        'CallBack','ACL(''Dicom'');',...
        'Tag','dicom','FontSize',7);
    
    uicontrol(PM,'String','Coreslice',...
        'Position',[183 326 59 059].*WS,...
        'ToolTipString','coregister and reslice images',...
        'CallBack','ACL(''Coreslice'');',...
        'Tag','coreslice','FontSize',7);
    
    uicontrol(PM,'String','Segment',...
        'Position',[237 326 59 059].*WS,...
        'ToolTipString','segment images',...
        'CallBack','ACL(''Segment'');',...
        'Tag','segment','FontSize',7);
    
    uicontrol(PM,'String','WMextraction',...
        'Position',[21 272 59 059].*WS,...
        'ToolTipString','white matter extraction',...
        'CallBack','ACL(''WMextraction'');',...
        'Tag','wmextraction','FontSize',7);
    
    uicontrol(PM,'String','Template',...
        'Position',[75 272 59 059].*WS,...
        'ToolTipString','Create Template of White Matter',...
        'CallBack','ACL(''Template'');',...
        'Tag','template','FontSize',7);
    
    uicontrol(PM,'String','MNI',...
        'Position',[129 272 59 059].*WS,...
        'ToolTipString','normalize to MNI space',...
        'CallBack','ACL(''mni'');',...
        'Tag','mni','FontSize',7);
    %% lesion
    uicontrol(PM,'String','LessionsNE',...
        'Position',[21 218 59 059].*WS,...
        'ToolTipString','Segment lessions & increase intesity of lesion',...
        'CallBack','ACL(''s_lessions'');',...
        'Tag','s_lesssion','FontSize',7);
    
    uicontrol(PM,'String','LessionsMNI',...
        'Position',[75 218 59 059].*WS,...
        'ToolTipString','Segment lessions & increase intesity of lesion',...
        'CallBack','ACL(''s_lessions_mni'');',...
        'Tag','s_lesssion_mni','FontSize',7);
    
    %% caracteristicas de lesiones
    uicontrol(PM,'String','VolumenNE',...
        'Position',[129 218 59 059].*WS,...
        'ToolTipString','calcula el volumen of lession en el espacio Nativo',...
        'CallBack','ACL(''volumenne'');',...
        'Tag','volumenne','FontSize',7);
    
    uicontrol(PM,'String','VolumenMNI',...
        'Position',[21 164 59 059].*WS,...
        'ToolTipString','calcula el volumen of lession en el espacio MNI',...
        'CallBack','ACL(''volumenmni'');',...
        'Tag','volumenmni','FontSize',7);
    
    uicontrol(PM,'String','CantidadNE',...
        'Position',[75 164 59 059].*WS,...
        'ToolTipString','calcula cantidad de lession en el espacio Nativo',...
        'CallBack','ACL(''cantidadne'');',...
        'Tag','cantidadne','FontSize',7);
    
    uicontrol(PM,'String','CantidadMNI',...
        'Position',[129 164 59 059].*WS,...
        'ToolTipString','calcula cantidad de lession en el espacio MNI',...
        'CallBack','ACL(''Cantidadmni'');',...
        'Tag','cantidadmni','FontSize',7);
    
    uicontrol(PM,'String','FractalidadNE',...
        'Position',[291 164 59 059].*WS,...
        'ToolTipString','calcula fractalidad promedio de lession en el espacio Nativo',...
        'CallBack','ACL(''Fractalidadne'');',...
        'Tag','fractalidadne','FontSize',6);
    
    uicontrol(PM,'String','FractalidadMNI',...
        'Position',[345 164 59 059].*WS,...
        'ToolTipString','calcula fractalidad promedio de lession en el espacio MNI',...
        'CallBack','ACL(''Fractalidadmni'');',...
        'Tag','fractalidadmni','FontSize',6);
    
    %       uicontrol(PM,'String','FractalidadMNI',...
    %           'Position',[345 164 59 059].*WS,...
    %       'ToolTipString','calcula fractalidad promedio de lession en el espacio MNI',...
    %       'CallBack','ACL(''Fractalidadmni'');',...
    %           'Tag','fractalidadmni','FontSize',6);
    
    uicontrol(PM,'String','IntensidadNE',...
        'Position',[237 164 59 059].*WS,...
        'ToolTipString','calcula intensidad promedio de lession en el espacio NE',...
        'CallBack','ACL(''IntensidadNE'');',...
        'Tag','intensidadne','FontSize',6);
    
    uicontrol(PM,'String','VolumenTalairachMNI',...
        'Position',[183 164 59 059].*WS,...
        'ToolTipString',...
        'Calcula volumen WML de de acuerdo al Talairach atlas, espacio MNI : 1)cerebellum, 2)frontal_lobe, 3)lt_hemisphere, 4)occipital_lobe, 5)parietal_lobe, 6)rt_hemisphere, 7)sub_lobar, 8)temporal_lobe   ',...
        'CallBack','ACL(''VolumenTalairachMNI'');',...
        'Tag','volumentalairachmni','FontSize',6);
    %% botones RESULT
    uicontrol(PM,'String','DISPLAY RESULTS',...
        'Position',[291 110 114 059].*WS,...
        'ToolTipString','muestra resultados obtenidos de sujetos y las lesiones en una tabla',...
        'CallBack','ACL(''results'');',...
        'ForegroundColor',spm('Colour'),...
        'Tag','results','FontSize',7);
    %% botones ANOVA
    uicontrol(PM,'String','ANOVA',...
        'Position',[291 56 114 059].*WS,...
        'ToolTipString','análisis estadistico de las caracteristicas de las lesiones',...
        'CallBack','ACL(''anova'');',...
        'ForegroundColor',spm('Colour'),...
        'Tag','anova','FontSize',7);
    
    
    %%
    ACL('SynchroniseButtons');
    %
    % Disable necessary buttons and parameters until phase-map is finished.
    %
    %       ACL('Reset_Gui');
    %=======================================================================
    %
    %=======================================================================
    case 'results'
        resultsTESIS_dos
        
        %=======================================================================
        %
        %=======================================================================
    case 'anova'
        anovaTESIS_dos
        
        %=======================================================================
        %
        %=======================================================================
    case 'volumentalairachmni'
        prop_lesTESIS_dos (IP.root,'talairach','MNI',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'intensidadne'
        prop_lesTESIS_dos (IP.root,'intensidad','NE',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'fractalidadmni'
        prop_lesTESIS_dos (IP.root,'fractalidad','MNI',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'fractalidadne'
        prop_lesTESIS_dos (IP.root,'fractalidad','NE',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'cantidadmni'
        prop_lesTESIS_dos (IP.root,'cantidad','MNI',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'cantidadne'
        prop_lesTESIS_dos (IP.root,'cantidad','NE',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'volumenmni'
        prop_lesTESIS_dos (IP.root,'volumen','MNI',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 'volumenne'
        prop_lesTESIS_dos (IP.root,'volumen','NE',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 's_lessions_mni'
        seg_lesTESIS_dos (IP.root,'MNI',IP.nofgrps)
        %=======================================================================
        %
        %=======================================================================
    case 's_lessions'
        seg_lesTESIS_dos (IP.root,'NE',IP.nofgrps)
        %=======================================================================
    case 'creategroups'
        
        prompt = {'Enter Study size:'};
        dlg_title = '# Folders for Clasificate';
        num_lines = 1;
        def = {'1'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        for dff = 1 : str2num(answer{1})
            nameofgroup{dff} =  inputdlg({'nombre de grupo # '},'Input',1,{strcat('Grupo#',num2str(dff))});
        end
        
        
        %=======================================================================
        %
        % clasifcate ing group of study
        %
        %=======================================================================
        % % % % % % % % % % % % %     case 'clasificate'
        %
        TB = figure('Position',[100 100 400 500]);
        
        %% lista de sujetos
        uicontrol(TB,'String','Save&OK',...
            'Position',[150 10 64 022].*WS,...
            'ToolTipString','guarda tabla de sujetos',...
            'CallBack','ACL(''save'');',...
            'Tag','save');
        %
        [filesSUBJ,dirsSUBJ] = spm_select('List', fullfile(IP.root,'forg2')); % select images for the smooth
        [nrows,ncols]= size(dirsSUBJ);
        
        filename = 'celldata2xx.txt';
        fid2 = fopen(filename, 'w');
        
        for row=1:nrows
            fprintf(fid2, '%s \n', dirsSUBJ(row,:));
        end
        
        fclose(fid2);
        %
        %     if ~exist('tabla.txt')
        fid = fopen('celldata2xx.txt');
        %     else
        %         fid = fopen('tabla.txt');
        %     end
        tline = fgetl(fid);
        i = 1;
        nomb(i,:) = tline;
        while ischar(tline)
            %disp(tline)
            i = i+1;
            nomb(i,:) = tline;
            tline = fgetl(fid);
        end
        fclose(fid);
        % creo tabla y pongo valores por default
        A =cellstr(nomb);
        [fm c]= size(A);
        for g=1 : fm
            A{g,2} = false;
            A{g,3} = char(nameofgroup{1});
        end
        IP.dat =  A;
        gconcat = '';
        for ngr = 1 : str2num(answer{1})
            gconcat = strcat (gconcat,char(nameofgroup{ngr}));
            campname {ngr} = char(nameofgroup{ngr});
        end
        IP.nofgrps = campname;
        columnname =   {'Name & Lastname_________', 'Available', gconcat};
        columnformat = {'char', 'logical', campname};
        columneditable =  [false true true]; % si se puede editar la tabal
        IP.t = uitable('Units','normalized','Position',...
            [0.1 0.1 0.9 0.9], 'Data', IP.dat,...
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', columneditable,...
            'RowName',[]);
        
        %=======================================================================
        %
        % Create Template of White Matter
        %
        %=======================================================================
    case 'save'
        %         cell2mat(IP.dat(:,1:3));
        IP.gh =get(IP.t,'Data');
        %         IP.gh(15,1:3);
        % class(IP.gh(1,2))
        fileID = fopen('tabla.txt','w');
        [f1 c1]= size(IP.gh);
        for h = 1: f1
            fprintf(fileID,'%s ',char(IP.gh(h,1)));
            fprintf(fileID,'%d ',cell2mat(IP.gh(h,2)));
            fprintf(fileID,'%s\n',char(IP.gh(h,3)));
        end
        
        fclose(fileID);
        clasificateTESIS_dos(IP.root,IP.gh,IP.nofgrps)
        close(TB);
        
        
        
        %=======================================================================
        %
        % Create Template of White Matter
        %
        %=======================================================================
    case 'mni'
        %
        mniTESIS_dos (IP.root,IP.nofgrps)
        
        
        %=======================================================================
        %
        % Create Template of White Matter
        %
        %=======================================================================
    case 'template'
        %
        tempTESIS_dos (IP.root,IP.nofgrps)
        
        
        %=======================================================================
        %
        % white matter extraction
        %
        %=======================================================================
    case 'wmextraction'
        %         dicom_convertTESIS_dos (IP.root)
        wm_extTESIS_dos (IP.root,IP.nofgrps)
        %=======================================================================
        %
        % coregister and reslice images
        %
        %=======================================================================
    case 'segment'
        %         dicom_convertTESIS_dos (IP.root)
        segment_Batch_dos (IP.root,IP.nofgrps)
        %=======================================================================
        %
        % coregister and reslice images
        %
        %=======================================================================
    case 'coreslice'
        
        coresliceTESIS_dos (IP.root,IP.nofgrps)
        
        %=======================================================================
        %
        % dicom impor
        %
        %=======================================================================
    case 'dicom'
        %         dicom_convertTESIS_dos (IP.root)
        ProTESIS_dos (IP.root,IP.nofgrps)
        %=======================================================================
        %
        % borra archivos de mas
        %
        %=======================================================================
        %     case 'clasificate'
        %         clean_StudyTESIS_dos (IP.root)
        %             clasificateTESIS_dos
        %=======================================================================
        %
        % agrupa imagenes de un paciente y las organiza con el nombre de cada uno
        %
        %=======================================================================
    case 'org_study'
        organizaTESISdos(IP.root);
        clean_StudyTESIS_dos (IP.root)
        m = msgbox('Por favor revise las carpetas de forg2 que contengan las 2 imagenes T1 & FLAIR','!! Warning !!','warn')
        %=======================================================================
        %
        % load folder with images Dicom
        % ACL ('load')
        %=======================================================================
    case 'load'
        if ~isempty(IP.uflags.iformat)
            if strcmp(IP.uflags.iformat,'AUTO');
                IP.flairdir = spm_select(1,'dir','Select Study ACL...')
            else
                display('prueba_manual')
                IP.flairdir = spm_select(1,'dir','Select Study ACL...')
            end
        else % Default
            IP.flairdir = spm_select(1,'dir','Select Study ACL...')
        end
        IP.root = IP.flairdir
        
        %=======================================================================
        %
        % Input format was changed
        %para que cambien los radiobuttons
        %=======================================================================
        
        
    case 'inputformat'
        %
        %       Enforce radio behaviour.
        %
        index = get(gcbo,'UserData');
        if index==1
            partner = 2;
            IP.uflags.iformat = 'AUTO';
        else
            partner = 1;
            IP.uflags.iformat = 'MANUAL';
        end
        
        h = findobj(get(PM,'Children'),'Tag','IFormat','UserData',partner);
        maxv = get(gcbo,'Max');
        value = get(gcbo,'Value');
        
        if value == maxv
            set(h,'Value',get(h,'Min'));
        else
            set(h,'Value',get(h,'Max'));
        end
        
        %       ACL('IFormat_Gui');
        %=======================================================================
        %
        % Make sure buttons reflect current parameter values
        %
        %=======================================================================
        
    case 'synchronisebuttons'
        
        % Set input format
        
        if ~isempty(IP.uflags.iformat)
            if strcmp(IP.uflags.iformat,'AUTO');
                h = findobj(get(PM,'Children'),'Tag','IFormat','UserData',1);
                ACL('RadioOn',h);
                IP.uflags.iformat = 'AUTO';
            else
                h = findobj(get(PM,'Children'),'Tag','IFormat','UserData',2);
                ACL('RadioOn',h);
                IP.uflags.iformat = 'MANUAL';
            end
        else % Default to RI
            h = findobj(get(PM,'Children'),'Tag','IFormat','UserData',1);
            ACL('RadioOn',h);
            IP.uflags.iformat = 'AUTO';
        end
        
        %=======================================================================
        %
        % Enforce radio-button behaviour
        %
        %=======================================================================
        
    case 'radioon'
        my_gcbo = varargin{2};
        index = get(my_gcbo,'UserData');
        if index==1
            partner=2;
        else
            partner=1;
        end
        set(my_gcbo,'Value',get(my_gcbo,'Max'));
        h = findobj(get(PM,'Children'),'Tag',get(my_gcbo,'Tag'),'UserData',partner);
        set(h,'Value',get(h,'Min'));
        %=======================================================================
        %=======================================================================
        %
        % The functions below are called by the various gui buttons but are
        % not dependent on the gui to work. These functions can therefore also
        % be called from a script bypassing the gui and can return updated
        % variables.
        %
        %=======================================================================
        %=======================================================================
        %
        %=======================================================================
        %
        % Create and initialise parameters for FieldMap toolbox
        %
        %=======================================================================
        
    case 'initialise'
        
        %
        % Initialise parameters
        %
        ID = cell(4,1);
        IP.P = cell(1,4);
        IP.pP = [];
        IP.fmagP = [];
        IP.wfmagP = [];
        IP.epiP = [];
        IP.uepiP = [];
        IP.nwarp = [];
        IP.fm = [];
        IP.vdm = [];
        IP.et = cell(1,2);
        IP.epifm = [];
        IP.blipdir = [];
        IP.ajm = [];
        IP.tert = [];
        IP.vdmP = []; %% Check that this should be there %%
        IP.maskbrain = [];
        IP.uflags = struct('iformat','','method','','fwhm',[],'bmask',[],'pad',[],'etd',[],'ws',[]);
        IP.mflags = struct('template',[],'fwhm',[],'nerode',[],'ndilate',[],'thresh',[],'reg',[],'graphics',0);
        
        % Initially set brain mask to be empty
        IP.uflags.bmask = [];
        % ACL
        IP.gh = [];
        IP.t = [];
        IP.dat = [];
        IP.flairdir = [];
        IP.root = [];
        % Set parameter values according to defaults
        ACL('SetParams');
        
        varargout{1}= IP;
        
        %=======================================================================
        %
        % Sets parameters according to the defaults file that is being passed
        %
        %=======================================================================
        
    case 'setparams'
        if nargin == 1
            % "Default" default file
            pm_defaults;
        else
            % Scanner or sequence specific default file
            %eval(varargin{2});
            spm('Run',varargin{2});
            pm_def = spm('GetGlobal','pm_def');
        end
        
        % Define parameters for fieldmap creation
        IP.et{1} = pm_def.SHORT_ECHO_TIME;
        IP.et{2} = pm_def.LONG_ECHO_TIME;
        IP.maskbrain = pm_def.MASKBRAIN;
        
        % Set parameters for unwrapping
        IP.uflags.iformat = pm_def.INPUT_DATA_FORMAT;
        IP.uflags.method = pm_def.UNWRAPPING_METHOD;
        IP.uflags.fwhm = pm_def.FWHM;
        IP.uflags.pad = pm_def.PAD;
        IP.uflags.ws = pm_def.WS;
        IP.uflags.etd = pm_def.LONG_ECHO_TIME - pm_def.SHORT_ECHO_TIME;
        
        % Set parameters for brain masking
        IP.mflags.template = pm_def.MFLAGS.TEMPLATE;
        IP.mflags.fwhm = pm_def.MFLAGS.FWHM;
        IP.mflags.nerode = pm_def.MFLAGS.NERODE;
        IP.mflags.ndilate = pm_def.MFLAGS.NDILATE;
        IP.mflags.thresh = pm_def.MFLAGS.THRESH;
        IP.mflags.reg = pm_def.MFLAGS.REG;
        IP.mflags.graphics = pm_def.MFLAGS.GRAPHICS;
        
        % Set parameters for unwarping
        IP.ajm = pm_def.DO_JACOBIAN_MODULATION;
        IP.blipdir = pm_def.K_SPACE_TRAVERSAL_BLIP_DIR;
        IP.tert = pm_def.TOTAL_EPI_READOUT_TIME;
        IP.epifm = pm_def.EPI_BASED_FIELDMAPS;
        
        %ACL
        IP.root =  pm_def.matlabroot;
        IP.nofgrps = [];
        varargout{1}= IP;
        %=======================================================================
        %
        % The following functions are GUI related functions that go on behind
        % the scenes.
        %=======================================================================
        %
        %=======================================================================
        %
        % Reset gui inputs when a new field map is to be calculated
        %
        %=======================================================================
        
    case 'reset_gui'
        
        % Clear any precalculated fieldmap name string
        uicontrol(PM,'Style','Text','String','',...
            'Position',[230 307 260 20].*WS,...
            'ForegroundColor','k','BackgroundColor',spm('Colour'));
        
        % Clear  Fieldmap values
        uicontrol(PM,'Style','Text',...
            'Position',[350 280 50 020].*WS,...
            'HorizontalAlignment','left',...
            'String','');
        
        % Disable input routes to make sure
        % a new fieldmap is calculated.
        %
        FieldMap('ToggleGUI','Off',char('CreateFieldMap','WriteFieldMap',...
            'LoadEpi','WriteUnwarped','MatchVDM',...
            'LoadStructural','MatchStructural',...
            'EPI','BlipDir',...
            'Jacobian','ReadTime'));
        %
        % A new input image implies all processed data is void.
        %
        IP.fm = [];
        IP.vdm = [];
        IP.jim = [];
        IP.pP = [];
        IP.epiP = [];
        IP.uepiP = [];
        IP.vdmP = [];
        IP.fmagP = [];
        IP.wfmagP = [];
        ID = cell(4,1);
        
        spm_orthviews('Reset');
        spm_figure('Clear','Graphics');
        %=======================================================================
        %
        % Use spm_help to display help for FieldMap toolbox
        %
        %=======================================================================
        % ACL('Help')
    case 'help'
        spm_help('ACL.man');
        
        %=======================================================================
    case 'quit'             %-Welcome splash screen
        %=======================================================================
        % ACL('Quit')
        %=======================================================================
        Fgraph=spm_figure('FindWin','Graphics');
        if ~isempty(Fgraph)
            if DGW
                delete(Fgraph);
                Fgraph=[];
                DGW = 0;
            else
                spm_figure('Clear','Graphics');
            end
        end
        PM=spm_figure('FindWin','ACL');
        if ~isempty(PM)
            delete(PM);
            PM=[];
        end
        if ~isempty(allchild(0))
            
            spm_figure('close',allchild(0));
        end
        local_clc;
        fprintf('Bye for now...\n\n');
        %=======================================================================
    case 'version'                                             %-SPM version
        %=======================================================================
        % v = spm('Version')
        %-----------------------------------------------------------------------
        varargout = {sprintf('%s%s%s%s','ACL Toolbox vesion: ',num2str(1),'.',num2str(0))};
        
end

%=======================================================================
function local_clc                                %-Clear command window
%=======================================================================
if ~isdeployed
    clc;
end
