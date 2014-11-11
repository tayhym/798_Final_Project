% Jeremie Kim
% 18-798 Image, Video, and Multimedia Processing
% webcam color blindness simulator

% change log: 11/11/14 : Matthew Tay
% code speedup for color conversion,
% color display from yuy2 space (conversion open-sourced)

imaqreset
vidobj=videoinput('macvideo',1);
triggerconfig(vidobj, 'manual');
t = timer('TimerFcn', 'disp(''webcam done''); run=false',... 
                 'StartDelay',40);
start(t);
run = true;
             
try 
    start(vidobj);
    hold on;
    figure(1);
    
    while (run) % Or any stop condition
        img = YUY2toRGB(double(getsnapshot(vidobj)));
    
        R = img(:,:,1);
        G = img(:,:,2);
        B = img(:,:,3);
        
        %transform to LMS space
        [L,M,S] = RGB_to_LMS(R,G,B);
        
        %transform to colorblind LMS values
        blind_type = 1; % to be changed by user input
        [L_new, M_new, S_new] = color_blind_sight(1,L,M,S);
        [R_new, G_new, B_new] = LMS_to_RGB(L_new, M_new, S_new);
        img_color_blind = cat(3,R_new,G_new, B_new);
        
        disp('displaying');
        subplot(1,2,1);image(uint8(img)); title('original image');
        subplot(1,2,2); image(uint8(img_color_blind)); title('color_blind image');
        drawnow;
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