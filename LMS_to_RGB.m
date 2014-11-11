% convert from LMS to RGB
function [R,G,B] = LMS_to_RGB(L,M,S)
    rgb_to_lms_mtx = [17.8824, 43.5161, 4.11935;
           3.45565, 27.1554, 3.86714;
           0.0299566, 0.184309, 1.46709];
%   out = (rgb_to_lms_mtx)\[L;M,S];
    mtx = inv(rgb_to_lms_mtx);
    R = mtx(1,1)*L + mtx(1,2)*M + mtx(1,3)*S;
    G = mtx(2,1)*L + mtx(2,2)*M + mtx(2,3)*S;
    B = mtx(3,1)*L + mtx(3,2)*M + mtx(3,3)*S;
end   