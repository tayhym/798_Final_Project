% Matthew Tay
% gui emulator wrapper for color-blind/video  

function simple_gui2()
    % SIMPLE_GUI2 Select a data set from the pop-up menu, then
    % click one of the plot-type push buttons. Clicking the button
    % plots the selected data in the axes.

    %  Create and then hide the GUI as it is being constructed.
    f = figure('Visible','off','Position',[360,500,700,285]);

    % Add pushbuttons
    start_video    = uicontrol('Style','pushbutton',...
                 'String','start_video','Position',[815,220,70,25], ...
                    'Callback',{@start_video_Callback});
    stop_video    = uicontrol('Style','pushbutton',...
                 'String','stop_video','Position',[815,180,70,25], ... 
                    'Callback',{@stop_video_Callback});
    extract_info = uicontrol('Style','pushbutton',...
                 'String','Extract Info','Position',[815,135,70,25], ...
                    'Callback',{@extract_info_Callback});

    % Add popup 
    htext  = uicontrol('Style','text','String','Type',...
               'Position',[325,90,60,15]);
    hpopup = uicontrol('Style','popupmenu',...
               'String',{'Protanopia','Deuteranopia','Tritanopia'},...
               'Position',[300,50,100,25], ...
               'Callback',{@popup_menu_Callback});        
    % Add axes 
     ha_one = axes('Units','pixels','Position',[50,60,200,185]);
     ha_two = axes('Units','pixels','Position',[300,60,200,185]);
%      ha_one = subplot(2,1,1);
%      ha_two = subplot(2,1,2);
%     set(ha_one,'Position',[50,60,200,185]); 
%     set(ha_two,'Position',[300,60,200,185]); 
    % Align components
    align([start_video,stop_video,extract_info,htext,hpopup],'Center','None');

    %-----------initialize gui with initial values----------% 
    % Initialize the GUI.
    % Change units to normalized so components resize automatically.
    set([f,start_video,stop_video,extract_info,htext,hpopup,ha_one,ha_two],'Units','normalized');

    % Generate the data to plot.
    peaks_data = peaks(35);
    membrane_data = membrane;
    [x,y] = meshgrid(-8:.5:8);
    r = sqrt(x.^2+y.^2) + eps;
    sinc_data = sin(r)./r;

    % Create a plot in the axes.
    current_data = peaks_data;
    surf(ha_one,current_data);
    surf(ha_two,current_data);
    current_data = 1; % set back to protanopia
    
    % Assign the GUI a name to appear in the window title.
    set(f,'Name', 'Color Blind Emulator and Analysis');
    % Move the GUI to the center of the screen.
    movegui(f,'center')

    % Make the GUI visible. set the global variable that can stop 
    % video capture
    set(f,'visible','on');
    stop_button_pushed = 0;
    current_img = cat(3,peaks_data,peaks_data,peaks_data); % image for extracting information
    started_video = 0;
    captured_frame = 0; % semaphore for extract info to proceed.
    extract_pushed = 0;
    %----------------call back functions--------------------%
    % Push button callbacks. Each callback plots current_data in the
    % specified plot type.

    function start_video_Callback(source,eventdata) 
    % start the video
        extract_pushed = 0;
        stop_button_pushed = 0; % undo any prev push of stop button
        started_video = 1;
        captured_frame = 0;
        type = current_data;
        imaqreset
        vidobj=videoinput('macvideo',1);
        triggerconfig(vidobj, 'manual');
        t = timer('TimerFcn', 'disp(''webcam done''); run=false',... 
                         'StartDelay',4000);
        start(t);
        run = true;
        try 
            start(vidobj);
            hold on;
            figure(1);

            while (run && ~stop_button_pushed & ~extract_pushed) % Or any stop condition
                img = YUY2toRGB(double(getsnapshot(vidobj)));
                current_img = img;
                
                R = img(:,:,1);
                G = img(:,:,2);
                B = img(:,:,3);

                %transform to LMS space
                [L,M,S] = RGB_to_LMS(R,G,B);

                %transform to colorblind LMS values
                [L_new, M_new, S_new] = color_blind_sight(type,L,M,S);
                [R_new, G_new, B_new] = LMS_to_RGB(L_new, M_new, S_new);
                img_color_blind = cat(3,R_new,G_new, B_new);

                disp('displaying');
                axes(ha_one); 
                image(uint8(img)); title('Normal Vision');
                
                axes(ha_two);
                image(uint8(flipud(fliplr((img_color_blind))))); title('Color-Blind Vision');
                view(2);
                drawnow;          
                captured_frame = 1;
            end
            stop(vidobj);
            imaqreset
        catch err
            fprintf('error occured!');
            stop(vidobj);
            imaqreset;
            close all;
            rethrow(err);
        end
    end

    function stop_video_Callback(source,eventdata) 
       extract_pushed = 0;
        % stop video
        stop_button_pushed = 1;
%         started_video = 0;
        captured_frame = 0;
    end

    function extract_info_Callback(source,eventdata) 
    extract_pushed = 1;
    % method to extract salient info that 
    % colorblind user needs to see 
    loading_img = imread('loading.jpeg');
    n_rows = 720;
    n_cols = 1280;
    if (started_video && captured_frame)   % must have started video to extract info  
        stop_button_pushed = 1;
        
        axes(ha_two);
        cla(ha_two);
        load_img = (multi_dimension_resize(loading_img,n_rows,n_cols));
        imshow(((load_img)));
        view(2);
        rescaled_image = imresize(current_img,0.1);
        extracted_img = fast_static_ishihara_extract(rescaled_image);
        extracted_img = imresize(extracted_img,[n_rows,n_cols]);
        
        axes(ha_two);
        imshow(uint8(((flipud(extracted_img))))); 
        reset(ha_two);
        title('Extracted Information');
        view(2);
        disp('test');
    end       
    end
    
    % Add selection of color blind type from popup menu
    %  Pop-up menu callback. Read the pop-up menu Value property to
    %  determine which item is currently displayed and make it the
    %  current data. This callback automatically has access to 
    %  current_data because this function is nested at a lower level.
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source,'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Protanopia' % User selects Peaks.
         current_data = 1;
      case 'Deuteranopia' % User selects Membrane.
         current_data = 2;
      case 'Tritanopia' % User selects Sinc.
         current_data = 3;
      end
   end
    
   
end

function [resized_img] = multi_dimension_resize(img,n_rows, n_cols)
    tmp_one = imresize(img(:,:,1),[n_rows,n_cols]);
    tmp_two = imresize(img(:,:,2),[n_rows,n_cols]);
    tmp_three = imresize(img(:,:,3),[n_rows,n_cols]);
    
    resized_img = cat(3,tmp_one,tmp_two,tmp_three);
end 
