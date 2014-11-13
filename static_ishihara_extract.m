% Jeremie Kim
% 18-798 Image, Video, and Multimedia Processing
% take in a static ishihara test and extract the data somehow


function y = static_ishihara_extract(image, blind_type)
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
    A = imread(image);
    [height width, depth] = size(A);
    LMS = zeros(height, width, depth);
    RGBp = zeros(height, width, depth);
    RGBd = zeros(height, width, depth);
    RGBt = zeros(height, width, depth);

    RGB_for_colorblind = zeros(height, width, depth);
        
    B = A;
    imshow(A);
    figure;
    R = A(:,:,1);
    G = A(:,:,2);
    B = A(:,:,3);
    
    
    for i=1:width
        for j=1:height
            key = strcat(sprintf('%03d', R(j, i)), ...
                         sprintf('%03d', G(j, i)), ... 
                         sprintf('%03d', B(j, i)));
            %key = A(j, i);
            % display(key);
            if (isKey(colors, key))
                colors(key) = colors(key) + 1;
            else
                colors(key) = 1;
            end
            
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
            
            if (blind_type == 1)
               RGB_for_colorblind(j, i, :) = double(rgb) - rgbp(:);
            elseif (blind_type == 2)
               RGB_for_colorblind(j, i, :) = double(rgb) - rgbd(:);
            elseif (blind_type == 3)
               RGB_for_colorblind(j, i, :) = double(rgb) - rgbt(:);
            end
            % keys(colors);
        end
    end
    
    imshow(uint8(RGBp));
    figure;
    imshow(uint8(RGBd));
    figure;
    imshow(uint8(RGBt));
    
    figure;
    imshow(uint8(RGB_for_colorblind));
    
    keys(colors)
    values(colors)
end