% convert from LMS to RGB
function [R,G,B] = LMS_to_RGB(L,M,S)
    rgb_to_lms_mtx = [17.8824, 43.5161, 4.11935;
           3.45565, 27.1554, 3.86714;
           0.0299566, 0.184309, 1.46709];

    out = (rgb_to_lms_mtx)\[L;M,S];
    R = out(1); G = out(2); B = out(3);
end 