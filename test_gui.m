% Generate the data to plot.
    peaks_data = peaks(35);
    membrane_data = membrane;
    [x,y] = meshgrid(-8:.5:8);
    r = sqrt(x.^2+y.^2) + eps;
    sinc_data = sin(r)./r;
    
    test_f = figure;
    ha_one = axes('Units','pixels','Position',[50,60,200,185]);
    ha_two = axes('Units','pixels','Position',[300,60,200,185]);
    img = imread('greens.jpg');
    img_two = imread('pout.tif');
    axes(ha_one); imagesc(img);
    axes(ha_two); imagesc(img_two);