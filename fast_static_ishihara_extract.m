% Jeremie Kim
% 18-798 Image, Video, and Multimedia Processing
% take in a static ishihara test and extract the data somehow

function [y,g1] = static_ishihara_extract(image)
    % blind_type(1) = protanopia
    lms2lmsp = [0 2.02344 -2.52581; 0 1 0; 0 0 1] ;
    % blind_type(2) = deuteranopia
    lms2lmsd = [1 0 0; 0.494207 0 1.24827; 0 0 1] ;
    % blind_type(3) = tritanopia
    lms2lmst = [1 0 0; 0 1 0; -0.395913 0.801109 0] ;
    
    rgb2lms = [17.8824 43.5161 4.11935; 3.45565 27.1554 3.86714; 0.0299566 0.184309 1.46709] ;
    lms2rgb = inv(rgb2lms) ;

    colors = containers.Map;
    lms    = containers.Map;
    A = image;    % (changed here)
    A = imresize(A, [250 250]);
    [height, width, depth] = size(A);

    LMS = zeros(height, width, depth);
    RGBp = zeros(height, width, depth);
    RGBd = zeros(height, width, depth);
    RGBt = zeros(height, width, depth);

    RGB_for_colorblind1 = zeros(height, width, depth);
    RGB_for_colorblind2 = zeros(height, width, depth);
    RGB_for_colorblind3 = zeros(height, width, depth);

    
    B = A;
%     figure;
%     subplot(2,2,1);
%     imshow(A);
%     title('Original', 'FontSize', 24);

    R = A(:,:,1);
    G = A(:,:,2);
    B = A(:,:,3);
        
    for i=1:width
        for j=1:height
            rgb = A(j, i, :);
            rgb = rgb(:);
            
            LMS(j, i, :) = double(rgb2lms) * double(rgb);
            lms = LMS(j, i, :);
            lms = lms(:);
            lmsp = lms2lmsp * lms;
            lmsp = lmsp(:);
            
            lmsd = lms2lmsd * lms;
            lmsd = lmsd(:);
            
            lmst = lms2lmst * lms;
            lmst = lmst(:);
            
            RGBp(j, i, :) = lms2rgb * lmsp;
            RGBd(j, i, :) = lms2rgb * lmsd;
            RGBt(j, i, :) = lms2rgb * lmst;
            
            rgbp = RGBp(j, i, :);
            rgbd = RGBd(j, i, :);
            rgbt = RGBt(j, i, :);
            
            %if (blind_type == 1)
               RGB_for_colorblind1(j, i, :) = double(rgb) - rgbp(:);
            %elseif (blind_type == 2)
               RGB_for_colorblind2(j, i, :) = double(rgb) - rgbd(:);
            %elseif (blind_type == 3)
               RGB_for_colorblind3(j, i, :) = double(rgb) - rgbt(:);
            %end
            % keys(colors);
        end
    end
    
%     subplot(2,2,2);
%     imshow(uint8(RGBp));
%     title('Protanopia', 'FontSize', 24);
    
%     subplot(2,2,3);
%     imshow(uint8(RGBd));
%     title('Deuteranopia', 'FontSize', 24);

%     subplot(2,2,4);
%     imshow(uint8(RGBt));
%     title('Tritanopia', 'FontSize', 24);
    %figure;
    %imshow(uint8(RGB_for_colorblind1));
    RGB_for_colorblind1 = rgb2gray(uint8(RGB_for_colorblind1));
    RGB_for_colorblind2 = rgb2gray(uint8(RGB_for_colorblind2));
    RGB_for_colorblind3 = rgb2gray(uint8(RGB_for_colorblind3));

    for i=1:width
        for j=1:height
            if(RGB_for_colorblind1(j, i) > 10)
               RGB_for_colorblind1(j, i) = 0;
            else
               RGB_for_colorblind1(j, i) = 255;
            end
        end
    end
    
    for i=1:width
        for j=1:height
            if(RGB_for_colorblind2(j, i) > 10)
               RGB_for_colorblind2(j, i) = 0;
            else
               RGB_for_colorblind2(j, i) = 255;
            end
        end
    end    
    
    for i=1:width
        for j=1:height
            if(RGB_for_colorblind3(j, i) > 10)
               RGB_for_colorblind3(j, i) = 0;
            else
               RGB_for_colorblind3(j, i) = 255;
            end
        end
    end    
    
%     figure, imshow(Iout1);
%     figure, imshow(Iout2);
%     figure, imshow(Iout3);

    final = zeros(height, width);
    for i=1:width
        for j=1:height
            if (RGB_for_colorblind1(j, i) == 255 | RGB_for_colorblind2(j, i) == 255 | RGB_for_colorblind3(j, i) == 255)
                final(j, i) = 255;
            else
                final(j, i) = 0;
            end
        end
    end
    
%     figure
%     imshow(final);
%     title('Extract Data', 'FontSize', 17);

    y = final;

end
