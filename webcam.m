% Jeremie Kim
% 18-798 Image, Video, and Multimedia Processing
% webcam color blindness simulator

% code taken from http://scien.stanford.edu/pages/labsite/2005/psych221/projects/05/ofidaner/conv_img.m


rgb2lms = [17.8824 43.5161 4.11935; 3.45565 27.1554 3.86714; 0.0299566 0.184309 1.46709] ;
lms2rgb = inv(rgb2lms) ;

lms2lmsp = [0 2.02344 -2.52581; 0 1 0; 0 0 1] ;
lms2lmsd = [1 0 0; 0.494207 0 1.24827; 0 0 1] ;
lms2lmst = [1 0 0; 0 1 0; -0.395913 0.801109 0] ;
LMS = zeros(480, 640, 3);
lms = zeros(480, 640, 3);
lmsp = zeros(480, 640, 3);
lmsd = zeros(480, 640, 3);
LMSp = zeros(480, 640, 3);
LMSd = zeros(480, 640, 3);
RGBp = zeros(480, 640, 3);
RGBd = zeros(480, 640, 3);

imaqreset
vidobj=videoinput('macvideo',1);

triggerconfig(vidobj, 'manual');

t = timer('TimerFcn', 'disp(''webcam done''); run=false',... 
                 'StartDelay',40);

start(t);
run = true;
             
try 
    start(vidobj);
    h = imshow(zeros(480, 640));
    hold on;
    [width, height] = size(h);
    figure(1);
    
    while (run) % Or any stop condition
        img = double(getsnapshot(vidobj));
        size_img = size(img);

        %transform to LMS space
        for i = 1:size_img(1)
            for j = 1:size_img(2)
                rgb = img(i,j,:);
                rgb = rgb(:);

                LMS(i,j,:) = rgb2lms * rgb;
            end
        end
        
        %transform to colorblind LMS values
        for i = 1:size_img(1)
            for j = 1:size_img(2)
                lms = LMS(i,j,:);
                lms = lms(:);

                LMS(i,j,:) = lms2lmsp * lms;
                %LMSd(i,j,:) = lms2lmsd * lms;
            end
        end

        %transform new LMS value to RGB values
        for i = 1:size_img(1)
            for j = 1:size_img(2)
                lmsp = LMS(i,j,:);
                lmsp = lmsp(:);

                %lmsd = LMSd(i,j,:);
                %lmsd = lmsd(:);

                LMS(i,j,:) = lms2rgb * lmsp;
                %RGBd(i,j,:) = lms2rgb * lmsd;

            end
        end

        
        % Process the frame.
        %img = rgb2gray(img);
        %img(:,:,2) = 0;
        %for i=1:width
        %    for j=1:height
        %        img(i,j,1) = img(i,j,1);
        %        img(i,j,2) = 
        %    end
        %end
        
        disp('displaying');
        imshow(uint8(LMS));
        %set(h, 'Cdata', img);
        drawnow;
    end
    stop(vidobj);
    imaqreset
    
catch err
    stop(vidobj);
    imaqreset
    rethrow(err);
end