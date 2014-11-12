% convert from LMS to RGB
% numerical ratios taken from http://ssodelta.wordpress.com/tag/rgb-to-lms/
% accessed 11/12/14
function [R,G,B] = LMS_to_RGB(L,M,S)
%     L_norm = L/255;
    rgb_to_lms_mtx = [17.8824, 43.5161, 4.11935;
           3.45565, 27.1554, 3.86714;
           0.0299566, 0.184309, 1.46709];
%   out = (rgb_to_lms_mtx)\[L;M,S];
    mtx = [0.0809,-0.1305,0.1167;
           -0.0102,0.0540,-0.1136;
           -0.0003,-0.0041,0.6935];
%     mtx = inv(rgb_to_lms_mtx);
    R = mtx(1,1)*L + mtx(1,2)*M + mtx(1,3)*S;
    G = mtx(2,1)*L + mtx(2,2)*M + mtx(2,3)*S;
    B = mtx(3,1)*L + mtx(3,2)*M + mtx(3,3)*S;
end   