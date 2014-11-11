%http://stackoverflow.com/questions/8901824/getsnapshot-speedup


vid = videoinput('macvideo', 1); %select input device

hvpc = vision.VideoPlayer;   %create video player object

src = getselectedsource(vid);
vid.FramesPerTrigger =1;
vid.TriggerRepeat = Inf;
vid.ReturnedColorspace = 'rgb';
%src.FrameRate = '30';
start(vid)

%start main loop for image acquisition
for t=1:500
  imgO=getdata(vid,1,'uint8');    %get image from camera
  
  % transform 
  hvpc.step(imgO);    %see current image in player
end