% Jeremie Kim
% 18-798 Image, Video, and Multimedia Processing
% take in a static ishihara test and extract the data somehow

function y = static_ishihara_extract(image)
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
    [height, width, depth] = size(A);

    LMS = zeros(height, width, depth);
    RGBp = zeros(height, width, depth);
    RGBd = zeros(height, width, depth);
    RGBt = zeros(height, width, depth);

    RGB_for_colorblind1 = zeros(height, width, depth);
    RGB_for_colorblind2 = zeros(height, width, depth);
    RGB_for_colorblind3 = zeros(height, width, depth);

    
    B = A;
    figure;
    subplot(2,2,1);
    imshow(A);
    title('Original', 'FontSize', 24);

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
    
    subplot(2,2,2);
    imshow(uint8(RGBp));
    title('Protanopia', 'FontSize', 24);
    
    subplot(2,2,3);
    imshow(uint8(RGBd));
    title('Deuteranopia', 'FontSize', 24);

    subplot(2,2,4);
    imshow(uint8(RGBt));
    title('Tritanopia', 'FontSize', 24);
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
    
    %figure;
    %imshow(RGB_for_colorblind1);
    
    h1 = fspecial('gaussian', size(RGB_for_colorblind1), 5.0);
    g1 = imfilter(RGB_for_colorblind1, h1);
  
    h2 = fspecial('gaussian', size(RGB_for_colorblind2), 5.0);
    g2 = imfilter(RGB_for_colorblind2, h2);
    
    h3 = fspecial('gaussian', size(RGB_for_colorblind3), 5.0);
    g3 = imfilter(RGB_for_colorblind3, h3);
    
    %figure;
    %imshow(g1);
    %title('Extract Data', 'FontSize', 17);
    
    for i=1:width
        for j=1:height
            if(g1(j, i) < 150)
               g1(j, i) = 0;
            else
               g1(j, i) = 255;
            end
        end
    end
    
    for i=1:width
        for j=1:height
            if(g2(j, i) < 150)
               g2(j, i) = 0;
            else
               g2(j, i) = 255;
            end
        end
    end
    
    for i=1:width
        for j=1:height
            if(g3(j, i) < 150)
               g3(j, i) = 0;
            else
               g3(j, i) = 255;
            end
        end
    end
    
    %figure;
    %imshow(g1);
    
    % remove blobs with area between LB and UB
    LB = 1000;
    UB = width * height;
    Iout1 = xor(bwareaopen(g1,LB),  bwareaopen(g1,UB));
    Iout2 = xor(bwareaopen(g2,LB),  bwareaopen(g2,UB));
    Iout3 = xor(bwareaopen(g3,LB),  bwareaopen(g3,UB));

    
    %figure, imshow(Iout1);
    %figure, imshow(Iout2);
    %figure, imshow(Iout3);

    final = zeros(height, width);
    for i=1:width
        for j=1:height
            if (Iout1(j, i) == 0 | Iout2(j, i) == 0 | Iout3(j, i) == 0)
                final(j, i) = 0;
            else
                final(j, i) = 255;
            end
        end
    end
    
    figure
    imshow(final);
    title('Extract Data', 'FontSize', 17);

    y = final;

end
