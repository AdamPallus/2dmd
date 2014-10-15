function motionfunction(inputmovie)
%GUI for the detectmotion function
%enables loading and manipuation of movies as well as error-catching for
%the input parameters of the detectmotion function.  
%USE:  motiongui or motiongui(inputmovie), where inputmovie is a 
%       three-dimensional array of grayscale frames.
%


%moviedata structure that will store the variables that change between
%functions.  It is passed from function to function via the userdata field
%of the mydata.hf handle.
%Written 2005-2007 Adam Pallus, Union College
if nargin==0
  moviedata.mov=zeros(100,100,1);
else
  moviedata.mov=inputmovie;
end
moviedata.movm=zeros(100,100,1);
moviedata.t=3;
moviedata.spacing=6;
moviedata.gsize=30;
moviedata.stdv1=3;
moviedata.stdv2=5;
moviedata.playfigure=0;
moviedata.playmotfigure=0;
moviedata.playsfigure=0;
moviedata.playtsfigure=0;
moviedata.thresh=0;%not user accessable with current gui
moviedata.scaling=1;
moviedata.hfradi=0;
moviedata.sradi=0;
moviedata.sthet=0;
%mydata structure will store handles for all of the GUI objects 
%main figure
mydata.hf=figure('name','Motion Detector GUI','numbertitle','off',...
    'menubar','none', 'color', [0 0 0]);
set(mydata.hf, 'userdata',moviedata);%moviedata struct used to hold the
                                   %variables that change between functions


mydata.h_busy=uicontrol(mydata.hf,'style','text',...
    'string','Processing...',...
    'position',[210 180 100 50], 'visible','off');                                   
                                   
                                   
 %frame by frame checkbox
 mydata.h_pause=uicontrol(mydata.hf,'style','check',...
    'position',[10 110 100 20],...
    'string','Frame by Frame');
%playmovie button- visible only after a movie is loaded
mydata.h_playmovie=uicontrol(mydata.hf,'Style','push',...
    'Position',[10 10 100 25],'string', 'Play Movie','visible','off',...
    'CallBack',{@playmoviecallback mydata});
%save menu
mydata.h_savemenu=uimenu(mydata.hf,'label','Save','position',2);
    mydata.h_savemotion=uimenu(mydata.h_savemenu,'label','Save Motion',...
        'Callback',{@savefile mydata 'motion'},'enable','off');
    mydata.h_savemovie=uimenu(mydata.h_savemenu,'label','Save Movie',...
        'callback',{@savefile mydata 'movie'},'enable','off');
    mydata.h_savematrix=uimenu(mydata.h_savemenu,'label',...
        'Save as matlab structure','enable','off',...
        'callback',{@savematrix mydata});
    mydata.h_savexl=uimenu(mydata.h_savemenu,'label',...
        'Save Frame Maxima in Excel Spreadsheet','enable','off',...
        'callback',{@savexl mydata});
    mydata.h_saverawxlm=uimenu(mydata.h_savemenu,'label',...
        'Save Raw Magnitudes in Excel Spreadsheet','enable','off',...
        'callback',{@saverawxl mydata 1});
    mydata.h_saverawxld=uimenu(mydata.h_savemenu,'label',...
        'Save Raw Directions in Excel Spreadsheet','enable','off',...
        'callback',{@saverawxl mydata 2});
    mydata.h_save3d=uimenu(mydata.h_savemenu,'label',...
        'Save 3d plot as Avi movie','enable','off',...
        'callback',{@save3d mydata});
    mydata.h_savepolar=uimenu(mydata.h_savemenu,'label',...
        'Save Polar Plot as Avi Movie','enable','off',...
        'callback',{@savepolar mydata});
%play motion button- visible only after motion has been detected
mydata.h_playmot=uicontrol(mydata.hf,'Style','push',...
    'Position',[10 70 100 25],...
    'string', 'Play Color','visible','off',...
    'CallBack',{@playmotcallback mydata});    
%polar plot menu- visible only after motion has been detected
mydata.h_plot=uimenu(mydata.hf,'label','Plot','enable','off',...
    'position',4);
mydata.h_polar=uimenu(mydata.h_plot,'label','Polar');  
  mydata.h_polarall=uimenu(mydata.h_polar,'label','Plot All',...
      'callback',{@polarall mydata});
  mydata.h_polarframe=uimenu(mydata.h_polar,'label','Frame by Frame',...
      'callback',{@polarframe mydata});
  mydata.h_plot3d=uimenu(mydata.h_plot,'label','Plot 3D',...
      'callback',{@plot3d mydata});
  mydata.h_3dmean=uimenu(mydata.h_plot,'label','Plot 3D mean',...
      'callback',{@plotmean mydata});
  %mydata.h_hist=uimenu(mydata.h_plot,'label','Show Histogram');
  %mydata.h_hisframe=uimenu(mydata.h_hist,'label','Frame by Frame','callback',{@histframe mydata});
  %mydata.h_histall=uimenu(mydata.h_hist,'label','Show All','callback',{@histall mydata});
%fit ellipse button
mydata.h_ell=uimenu(mydata.h_polar,...     
      'label','Fit Ellipse','visible','off',...
      'callback',{@fitellipse mydata});
%play filter menu
mydata.h_filter=uimenu(mydata.hf,'label','Filter','enable', 'off',...
    'position', 5);
mydata.h_sfilter=uimenu(mydata.h_filter,'label','Show Spatial Filter',...
    'callback',{@playsfiltercallback mydata});
mydata.h_tsfilter=uimenu(mydata.h_filter,'label','Show Temporal Filter',...
    'callback',{@playtsfiltercallback mydata});
%colorplot button
mydata.h_plotcolor=uicontrol(mydata.hf,'style','push',...
    'position',[120 10 100 25],...
    'string','Detect Color','visible','off',...
    'callback',{@plotcolor mydata});
    
%detect motion button- visible only after a movie has been loaded
mydata.h_detectmotion=uicontrol(mydata.hf,'Style','push',...
    'Position',[10 40 100 25],...
    'string','Detect Motion', 'visible','off',...
    'Callback',{@detectmotioncallback mydata});
 %image menu- crop or resize movie once loaded 
mydata.h_imagemenu=uimenu(mydata.hf,'label','Image','enable','off',...
    'position',3);
    
    mydata.h_undo=uimenu(mydata.h_imagemenu,'label','Undo Last Change',...
        'callback',{@undo mydata},'enable','off');
    mydata.h_ptsize=uimenu(mydata.h_imagemenu,'label','Measure Selection',...
        'callback',{@ptsize mydata});
    mydata.h_imagecrop=uimenu(mydata.h_imagemenu,'label','Crop Movie',...
        'callback',{@clipmovie mydata});
    mydata.h_imresize=uimenu(mydata.h_imagemenu,'label','Resize Movie');
        mydata.h_res=uimenu(mydata.h_imresize,'label','Custom',...
            'callback',{@resizemovie mydata});
        mydata.h_res50=uimenu(mydata.h_imresize,'label','50%',...
            'callback',{@resizemovie mydata .5});
        mydata.h_res75=uimenu(mydata.h_imresize,'label','75%',...
            'callback',{@resizemovie mydata .75});
        mydata.h_res90=uimenu(mydata.h_imresize,'label','90%',...
            'callback',{@resizemovie mydata .75});
    
if nargin==1
    
    %enable buttons and menus that can now be activated
    set(mydata.h_playmovie,'visible','on');
    set(mydata.h_detectmotion,'visible','on');
    set(mydata.h_savemotion,'enable','off');
    set(mydata.h_save3d,'enable','off');
    set(mydata.h_savepolar,'enable','off');
    set(mydata.h_savexl,'enable','off');
    set(mydata.h_saverawxlm,'enable','off');
    set(mydata.h_saverawxld,'enable','off');
    set(mydata.h_imagemenu,'enable','on');
    set(mydata.h_savemovie,'enable','on');
end
   %load menu- load movie or .tiff frames
mydata.h_loadmenu=uimenu(mydata.hf,'label','Load','position',1);
    mydata.h_newmovie=uimenu(mydata.h_loadmenu,'label', 'Load Movie',...
        'Callback',{@loadmovie mydata});
   mydata.h_loadtiff=uimenu(mydata.h_loadmenu,'label','Load Tiff Images',...
        'callback',{@loadtiff mydata});
%tau slider bar 
mydata.h_tslider=uicontrol(mydata.hf,'Style','slider',...
    'Position',[10 330 140 20],'Min',0.5,'Max',50,'Value',moviedata.t);
    %'callback',{@tslidercallback mydata});
    mydata.h_tcur=uicontrol(mydata.hf,'style','edit',...
        'position',[60 350 45 20],...
        'string',sprintf('%.3g',get(mydata.h_tslider,'value')),...
        'callback',{@teditcallback mydata});
    set(mydata.h_tslider, 'callback',{@tslidercallback mydata});
    mydata.h_tmin=uicontrol(mydata.hf,'style','text',...
        'position',[10 350 40 20],...
        'string',num2str(get(mydata.h_tslider,'min')));
    mydata.h_tmax=uicontrol(mydata.hf,'style','text',...
        'position',[110 350 40 20],...
        'string',num2str(get(mydata.h_tslider,'max')));
    mydata.h_tlabel=uicontrol(mydata.hf,'style','text',...
        'position',[40 370 90 20],...
        'string','Value of t:'); 
    %standard deviaton edit boxes
mydata.h_stdvlabel=uicontrol(mydata.hf,'style','text',...
    'position',[20 180 130 20],'string','Stdv of Gaussians:');
     mydata.h_stdv1=uicontrol(mydata.hf,'style','edit',...
         'position',[40 160 45 20],...
         'string',sprintf('%d',round(moviedata.stdv1)),...
         'callback', {@stdv1callback mydata});
     mydata.h_stdv2=uicontrol(mydata.hf,'style','edit',...
         'position',[90 160 45 20],...
         'string',sprintf('%d',round(moviedata.stdv2)),...
         'callback',{@stdv2callback mydata});
%spacing slider
mydata.h_sslider=uicontrol(mydata.hf,'Style','slider',...
    'Position',[10 250 140 20],'Min',1,'Max',50,'Value',moviedata.spacing);
    
    mydata.h_scur=uicontrol(mydata.hf,'style','edit',...
        'position',[60 270 45 20],...
        'string',sprintf('%d',round(get(mydata.h_sslider,'value'))),...
        'callback',{@seditcallback mydata});
    set(mydata.h_sslider,'callback',{@sslidercallback mydata});
    mydata.h_smin=uicontrol(mydata.hf,'style','text',...
        'position',[10 270 40 20],...
        'string',num2str(get(mydata.h_sslider,'min')));
    mydata.h_smax=uicontrol(mydata.hf,'style','text',...
        'position',[110 270 40 20],...
        'string',num2str(get(mydata.h_sslider,'max')));
    mydata.h_slabel=uicontrol(mydata.hf,'style','text',...
        'position',[40 290 90 20],...
        'string','Size of Spacing:'); 
%gsize edit box
mydata.h_gsize=uicontrol(mydata.hf,'style','edit',...
    'position',[60 200 45 20],...
    'string',sprintf('%d',round(moviedata.gsize)),...
    'callback',{@gsizecallback mydata});
mydata.h_glabel=uicontrol(mydata.hf,'style','text',...
    'position',[40 220 90 20],'string','Size of Filter:');


%scaling edit box
mydata.h_scalinglabel=uicontrol(mydata.hf,'style','text',...
    'position',[20 130 45 20],'string','Scaling');
mydata.h_scaling=uicontrol(mydata.hf,'style','edit',...
    'position',[70 130 45 20],'string',sprintf('%.3g',moviedata.scaling),...
    'callback',{@scalingcallback mydata});
%display color wheel
 imshow('colorscheme2.bmp') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ClipMovie%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%allows user to select a portion of the movie using the mouse.  
%this replaces moviedata.mov with the selected portion of each frame
%the user must make the selection based on the first frame of the movie
%and is given a confirmation box upon completion of the selection
function clipmovie(cbo, eventdata, mydata)
moviedata=get(mydata.hf,'userdata');
temp=moviedata.mov(:,:,1);
hc=figure('name', 'Drag mouse over desired section','numbertitle',...
    'off','menubar', 'none');
%if max(max(temp))~=0
%    temp=temp/max(max(temp));
%end
imshow(temp);
pt.pt1=[];
pt.pt2=[];
set(hc,'userdata',pt);
set(hc,'windowbuttondownfcn',@clipdown);
set(hc,'windowbuttonupfcn',{@trimclip mydata});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%subFunction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                              %%%clipdown%%%
%sub function for the clip movie function
function clipdown(cbo, eventdata)
    pt=get(cbo,'userdata');
    pt.pt1=get(gca, 'currentpoint');
    set(cbo,'userdata',pt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%subFunction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%trimclip%%%%%%
%subfunction for clipmovie function
function trimclip(cbo, eventdata, mydata)
    pt=get(cbo,'userdata');
    pt.pt2=get(gca, 'currentpoint');
    moviedata=get(mydata.hf,'userdata');
    temp=moviedata.mov(:,:,1);
    xlim=get(gca,'xlim');
    ylim=get(gca,'ylim');
    pt1=round(pt.pt1(1,1:2));
    pt2=round(pt.pt2(1,1:2));
    ysel=sort([pt1(1),pt2(1)]);
    xsel=sort([pt1(2),pt2(2)]);
    maxx=size(temp,1);maxy=size(temp,2);
    if xsel<maxx & ysel<maxy & xsel>=0 & ysel>=0
        temp(xsel(1):xsel(2),ysel(1):ysel(2))=temp(xsel(1):xsel(2),...
            ysel(1):ysel(2))*.5;
        %if max(max(temp))~=0
        %    temp=temp/max(max(temp));
        %end
        imshow(temp);
        answer=questdlg('Trim to this selection?','Trim Movie?',...
            'Yes','No','No');
        if strcmp(answer,'Yes')
            moviedata.oldmov=moviedata.mov;
            set(mydata.h_undo,'enable','on');
            moviedata.mov=moviedata.mov(xsel(1):xsel(2),ysel(1):ysel(2),:);
            set(mydata.hf,'userdata',moviedata');
        end
        close(cbo);
    else
        errordlg('You must select a region within the image',...
            'Seletion Out of Bounds');
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ptsize%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%allows user to select a portion of the movie using the mouse  
%and reports the size of the selection.
function ptsize(cbo, eventdata, mydata)
moviedata=get(mydata.hf,'userdata');
temp=moviedata.mov(:,:,1);
hc=figure('name', 'Drag mouse over desired section','numbertitle',...
    'off','menubar', 'none');
%if max(max(temp))~=0
%    temp=temp/max(max(temp));
%end
imshow(temp);
pt.pt1=[];
pt.pt2=[];
set(hc,'userdata',pt);
set(hc,'windowbuttondownfcn',@ptdown);
set(hc,'windowbuttonupfcn',{@ptmeasure mydata});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%subFunction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                              %%%clipdown%%%
%sub function for the clip movie function
function ptdown(cbo, eventdata)
    pt=get(cbo,'userdata');
    pt.pt1=get(gca, 'currentpoint');
    set(cbo,'userdata',pt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%subFunction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%trimclip%%%%%%
%subfunction for clipmovie function
function ptmeasure(cbo, eventdata, mydata)
    pt=get(cbo,'userdata');
    pt.pt2=get(gca, 'currentpoint');
    moviedata=get(mydata.hf,'userdata');
    temp=moviedata.mov(:,:,1);
    xlim=get(gca,'xlim');
    ylim=get(gca,'ylim');
    pt1=round(pt.pt1(1,1:2));
    pt2=round(pt.pt2(1,1:2));
    ysel=sort([pt1(1),pt2(1)]);
    xsel=sort([pt1(2),pt2(2)]);
    maxx=size(temp,1);maxy=size(temp,2);
    if xsel<maxx & ysel<maxy & xsel>=0 & ysel>=0
        temp(xsel(1):xsel(2),ysel(1):ysel(2))=temp(xsel(1):xsel(2),...
            ysel(1):ysel(2))*.5;
        %if max(max(temp))~=0
        %    temp=temp/max(max(temp));
        %end
        imshow(temp);
        y=xsel(2)-xsel(1);
        x=ysel(2)-ysel(1);
        d=sqrt(y^2+x^2);
        msgbox(['Selection is ' num2str(x) ' by ' num2str(y) ' pixels.  d = ' num2str(d) '.']);
        uiwait();
        imshow(moviedata.mov(:,:,1));
    else
        errordlg('You must select a region within the image',...
            'Seletion Out of Bounds');
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%detectmotioncallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calls the detectmotion function with all of the parameters specified by
%the moviedata structure stored in mydata.hf's userdata field.
%the moviedata structure is then updated and the appropriate GUI elements
%are enabled 
function detectmotioncallback(cbo, eventdata, mydata)
moviedata=get(mydata.hf, 'userdata');
if size(moviedata.mov(:),1)>14000000
    errordlg(['Movie is too large; Please resize or crop the ',...
    'movie before continuing.  Maxium size is 14,000,000 pixels.',...
    'The movie is currently ',num2str(size(moviedata.mov(:),1)),...
    ' pixels'],'Not Enough Memory');
else
    moviedata.movm=[];
    moviedata.radi=[];
    moviedata.thet=[];
    moviedata.sfilter=[];
    moviedata.tsfilter=[];
    moviedata.mx=[];
    moviedata.my=[];
    set(mydata.hf,'userdata',moviedata);
set(mydata.h_busy,'visible','on');
drawnow

%contrast=mean(mean(moviedata.mov(:,:,1))); %rescale to remove brightness
%mov=moviedata.mov/contrast; %average brightness will be one
mov=moviedata.mov;
%changed to detectmotion from detectmotion2
mdata=detectmotion(mov,moviedata.spacing,moviedata.t,...
    moviedata.gsize,moviedata.stdv1,moviedata.stdv2);
moviedata.movm=zeros(10,10,size(moviedata.mov,3));
moviedata.radi=mdata.radi;%*10000;%scale data for plotting
moviedata.thet=mdata.thet;
moviedata.sfilter=mdata.sfilter;
moviedata.tsfilter=mdata.tsfilter;
%moviedata.mx=mdata.mx;
%moviedata.my=mdata.my;
moviedata.hfradi=0;
moviedata.sradi=0;
moviedata.sthet=0;

set(mydata.hf,'userdata',moviedata);

set(mydata.h_playmot,'visible','off');
set(mydata.h_busy,'visible','off');
set(mydata.h_plotcolor,'visible','on');
set(mydata.h_savemotion,'enable','on');
set(mydata.h_save3d,'enable','on');
set(mydata.h_savepolar,'enable','on');
set(mydata.h_savexl,'enable','on');
set(mydata.h_saverawxlm,'enable','on');
set(mydata.h_saverawxld,'enable','on');
set(mydata.h_savematrix,'enable','on');
set(mydata.h_savexl,'enable', 'on');
set(mydata.h_plot,'enable','on');
set(mydata.h_ell,'visible','on');
set(mydata.h_filter,'enable', 'on');
uiresume()
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%fitellipse%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%converts the polar points given by radi and thet fields of moviedata into
%rectangular points and plots them in a new figure.  The fit_ellipse
%function is then called which displays a red ellipse on the figure.
%see the fit_ellipse function for details about how the ellipse is
%calculated
function fitellipse(cbo, eventdata, mydata)
moviedata=get(mydata.hf, 'userdata');
f_ell=figure('name' , 'Best Fit Ellipse', 'numbertitle', 'off',...
    'menubar', 'none');

ind=find(moviedata.radi(:)>moviedata.thresh);

plot(moviedata.radi(ind).*cos(moviedata.thet(ind)),...
    moviedata.radi(ind).*sin(moviedata.thet(ind)),'.k');
axis equal;
Ellipse=fit_ellipse(moviedata.radi(ind).*cos(moviedata.thet(ind)),...
    moviedata.radi(ind).*sin(moviedata.thet(ind)),gca);
h_longtitle=uicontrol(f_ell,'style','text','string','Long Axis',...
    'position',[110 400 90 20]);
h_longvalue=uicontrol(f_ell,'style','text','string',...
    num2str(Ellipse.long_axis),'position',[110 380 90 20]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gsizecallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%updates the gsize field of the moviedata structure as specified by the 
%editbox-- The value entered must be a number between 0 and 300
function gsizecallback(cbo, eventdata, mydata)
if str2num(get(cbo,'string'))>0&str2num(get(cbo,'string'))<300
    moviedata=get(mydata.hf, 'userdata');
    moviedata.gsize=round(str2num(get(cbo,'string')));
    set(mydata.hf, 'userdata', moviedata);
else
    errordlg('You must enter a value between 0 and 300','Invalid Entry');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HistAll%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function histall(cbo, eventdata, mydata)
moviedata=get(mydata.hf, 'userdata');
thresh=moviedata.thresh;
if moviedata.sradi==0
    theta=moviedata.thet;
    radia=moviedata.radi;
    count=1;
    for i = 1:size(theta(:))
        if radia(i)>thresh
            radi(count)=radia(i);
            thet(count)=theta(i);
            count=count+1;
        end
    end
    moviedata.sradi=radi;
    moviedata.sthet=thet;
    set(mydata.hf,'userdata',moviedata')
else
    radi=moviedata.sradi;
end
f_hist=figure('name' , ['Histogram   t=' num2str(moviedata.t),...
    ' Spacing=' num2str(moviedata.spacing)], 'numbertitle','off',...
    'menubar', 'none');
hist(radi(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HistFrame%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function histframe(cbo, eventdata, mydata)
moviedata=get(mydata.hf, 'userdata');

ind=find(moviedata.radi>moviedata.thresh);

h2=figure('name','Motion Detected','numbertitle','off');
h1=figure('name','Histogram of Intensities','numbertitle','off','menubar', 'none');

for i=1:size(moviedata.radi,2)
    figure(h1);
    set(h1,'name',['Histogram of Intensities, frame:  ',num2str(i)]);
    temp=moviedata.radi(:,:,i);
    ind=find(temp>moviedata.thresh);
    hist(temp(ind));
    try
        figure(h2)
        imshow(moviedata.movm(:,:,:,i));
    catch
        %if max(max(max(moviedata.mov)))~=0
        %    x=max(max(max(moviedata.mov)));
        %end
        imshow(moviedata.mov(:,:,i)/x);
        set(h2,'name',['Movie frame:  ',num2str(i)]);
    end
    if get(mydata.h_pause, 'value')==1
        waitforbuttonpress;
    else
        pause(0.5)
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Load Movie%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loadmovie(cbo, eventdata,mydata)
%loads movie from avi or wmv files
%the loaded movie is stored in moviedata.mov, in the userdata field of hf
%See the m-file for the mmread function for more information
%If the movie to be loaded is longer than 30 frames, the user is offered a
%chance to preview the movie and then asked to indicate which frames of the
%movie should be loaded.  If the movie is 30 frames or less, the entire
%movie will be loaded without further user input.
[datafile datapath]=uigetfile({'*.avi;*.wmv;*.mpg;*.mpeg','Movie Files'},...
    'Choose a saved movie');
try
if datafile
    [b,r]=strtok(datafile,'.');
    
    %if r=='.avi'|r=='.wmv'
        set(mydata.h_busy,'visible','on');
        drawnow
        video=mmread([datapath datafile],[],[0,20],false,true);
        set(mydata.h_busy,'visible','off');
        drawnow
        answer=0;
        if video.nrFramesTotal>30
            answer=questdlg('Preview Movie?','preview','Yes','No','No');
        end
        if strcmp(answer,'Yes')
            h_prv=figure('name', 'Movie Preview','numbertitle','off',...
                'position',[500,500,video.width,video.height]);
        end
        while strcmp(answer,'Yes')
            for i = 1:video.nrFramesTotal
                movie(h_prv,video.frames(i))
               set(h_prv,'name',['Frame: ',num2str(i)]);
            end
            answer=questdlg('Preview Movie Again?','preview','Yes','No','No');
            if strcmp(answer,'No')
                close(h_prv);
            end
        end
        
        success=0;
        while success==0
            if video.nrFramesTotal>30
                answer = inputdlg(['movie has ',num2str(video.nrFramesTotal),...
                ' frames.  Which do you want? eg: 10-20'],'Which Frames?');
                if isempty(answer)
                    return
                end
                [strt,stp]=strtok(answer{1},'-');
                if ischar(strt)
                    strt=str2num(strt);
                end
                if ischar(stp)
                    stp=str2num(strtok(stp,'-'));
                end
            else
                strt=1;
                stp=video.nrFramesTotal;
            end
            if strt>0&strt<=video.nrFramesTotal
                if stp>strt&stp<=video.nrFramesTotal
                    success=1;
                end
            end
        end %end while
      
        set(mydata.h_busy,'visible','on');
        drawnow
        for i=1:stp-strt+1
            temp=frame2im(video.frames(i+strt-1));
            x(:,:,i)=rgb2gray(temp);
        end
        moviedata=get(mydata.hf,'userdata');
        moviedata.mov=x;
        set(mydata.hf,'userdata',moviedata,'name',...
            ['Motion Detector GUI - ',datafile]);
    %else
    %      errordlg('unsupported file type');
    %end    
end
%enable buttons and menus that can now be activated
set(mydata.h_busy,'visible','off');
set(mydata.h_playmovie,'visible','on');
set(mydata.h_detectmotion,'visible','on');
set(mydata.h_savemotion,'enable','off');
set(mydata.h_save3d,'enable','off');
set(mydata.h_savepolar,'enable','off');
set(mydata.h_savexl,'enable','off');
set(mydata.h_saverawxlm,'enable','off');
set(mydata.h_saverawxld,'enable','off');
set(mydata.h_imagemenu,'enable','on');
set(mydata.h_savemovie,'enable','on');
set(mydata.h_plotcolor,'visible','off');
set(mydata.h_playmot,'visible','off');
set(mydata.h_plot,'enable','off');
set(mydata.h_filter,'enable','off');

catch
           
            errordlg(lasterr)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LoadTiff%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%same as loadmovie, but loads a movie from .tiff or .jpg images
%the images will be ordered alphabetically and combined to form a video
%clip, so be sure to name the images accordingly.
function loadtiff(cbo, eventdata, mydata)

[datafiles datapath fileindex]=uigetfile({'*.tiff;*.tif;*.jpg;*.jpeg',...
    'image files'},'Select Image Frames','multiselect','on');
if ~isequal(datafiles,0)
datafiles=sort(datafiles);
[b,r]=strtok(datafiles{1},'.');

set(mydata.h_busy,'visible','on');
        drawnow
for i=1:length(datafiles)
    tempimage=imread([datapath datafiles{i}],strtok(r,'.'));
    mov(:,:,i)=rgb2gray(tempimage);
end
moviedata=get(mydata.hf,'userdata');
moviedata.mov=uint8(mov);

set(mydata.hf,'userdata',moviedata);
else 
    if fileindex
        errordlg(['unsupported file type:',lasterr]);
    end
end   
set(mydata.h_busy,'visible','off');
        drawnow

set(mydata.h_playmovie,'visible','on');
set(mydata.h_detectmotion,'visible','on');
set(mydata.h_savemotion,'enable','off');
set(mydata.h_save3d,'enable','off');
set(mydata.h_savepolar,'enable','off');
set(mydata.h_savexl,'enable','off');
set(mydata.h_saverawxlm,'enable','off');
set(mydata.h_saverawxld,'enable','off');
set(mydata.h_imagemenu,'enable','on');
set(mydata.h_savemovie,'enable','on');
set(mydata.h_plotcolor,'visible','off');
set(mydata.h_playmot,'visible','off');
set(mydata.h_plot,'enable','off');
set(mydata.h_filter,'enable','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%playmotioncallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the playmotion button, this function displays the calculated
%motion in RGB color.  If the frame by frame checkbox is enabled, the user
%will be required to click on the figure before the next frame will be
%displayed.
function playmotcallback(cbo, eventdata, mydata)
    moviedata=get(mydata.hf,'userdata');
    x=moviedata.movm;
    if moviedata.playmotfigure==0
        moviedata.playmotfigure=figure('name', 'The Motion Detected',...
            'numbertitle','off','menubar', 'none');
        set(mydata.hf,'userdata',moviedata);
    else
        figure(moviedata.playmotfigure);
        set(moviedata.playmotfigure,'name', 'The Motion Detected',...
        'numbertitle','off','menubar','none');
    end
    %if max(max(max(x)))~=0
    %    x=x/max(max(max(x)));
    %end         
    for i=1:size(x,4)
        if i>1&get(mydata.h_pause,'value')==1
            waitforbuttonpress;
        end
        set(moviedata.playmotfigure,'name',['Frame: ',num2str(i)]);
        if gcf==moviedata.playmotfigure
            figure(moviedata.playmotfigure)
            try
                imshow(x(:,:,:,i));
            catch
                try
                    close(moviedata.playmotfigure);
                end
                return
            end
        else
            try
                close(moviedata.playmotfigure);
            end
            return
        end
    end
    if get(mydata.h_pause,'value')==1
        waitforbuttonpress; 
        close(moviedata.playmotfigure);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%PlayMovieCallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the playmovie functon-displays the movie 
%if the frame by frame checkbox is enabled, the movie will pause at each
%frame until the user clicks on the figure
function playmoviecallback(cbo, eventdata, mydata)
    moviedata=get(mydata.hf,'userdata');
    x=moviedata.mov;    
    if moviedata.playfigure==0
        moviedata.playfigure=figure('name', 'The Movie','numbertitle','off');
        set(mydata.hf,'userdata',moviedata);
    else
        figure(moviedata.playfigure);
        set(moviedata.playfigure,'name', 'The Movie','numbertitle','off');
    end
    %if get(mydata.h_pause,'value')==1
    %    h_framenum=uicontrol(moviedata.playfigure,'style','text','string','Frame Number',...
    %        'position',[110 400 90 20]);
    %    h_framevalue=uicontrol(moviedata.playfigure,'style','text','string',...
    %        '1','position',[110 380 90 20]);
    %end
    %if max(max(max(x)))~=0
    %    x=x/max(max(max(x)));
    %end         
    
    for i=1:size(x,3)
        if i>1&get(mydata.h_pause,'value')==1
   %         set(h_framevalue,'string',num2str(i));
            waitforbuttonpress;
        end
        set(moviedata.playfigure,'name',['Frame: ',num2str(i)]);
        
        if gcf==moviedata.playfigure
            figure(moviedata.playfigure)
            try
                imshow(x(:,:,i));
            catch
                try
                    close(moviedata.playfigure);
                end
                return
            end
        else
            try
               close(moviedata.playfigure);
            end
            return
        end
    end
    if get(mydata.h_pause,'value')==1
        waitforbuttonpress; 
        close(moviedata.playfigure);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%PlaySFilterCallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the playmovie functon-displays the movie 
%if the frame by frame checkbox is enabled, the movie will pause at each
%frame until the user clicks on the figure
function playsfiltercallback(cbo, eventdata, mydata)
    moviedata=get(mydata.hf,'userdata');
    %max(moviedata.sfilter(:))
    %class(moviedata.sfilter)
    x=double(moviedata.sfilter)-min(moviedata.sfilter(:));
    x=x/max(x(:));
    if moviedata.playsfigure==0
        moviedata.playsfigure=figure('name', 'The Spatially Filtered Movie','numbertitle','off');
        set(mydata.hf,'userdata',moviedata);
    else
        figure(moviedata.playsfigure);
        set(moviedata.playsfigure,'name', 'The Spatially Filtered Movie','numbertitle','off');
    end
    %if max(max(max(x)))~=0
    %    x=x/max(max(max(x)));
    %end         
    for i=1:size(x,3)
        if i>1&get(mydata.h_pause,'value')==1
            waitforbuttonpress;
        end
        figure(moviedata.playsfigure)
        imshow(x(:,:,i));
    end
    if get(mydata.h_pause,'value')==1
        waitforbuttonpress; 
        close(moviedata.playsfigure);
    end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%PlayTSFilterCallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the playmovie functon-displays the movie 
%if the frame by frame checkbox is enabled, the movie will pause at each
%frame until the user clicks on the figure
function playtsfiltercallback(cbo, eventdata, mydata)
    moviedata=get(mydata.hf,'userdata');
    x=double(moviedata.tsfilter)-min(moviedata.tsfilter(:));
    if moviedata.playtsfigure==0
        moviedata.playtsfigure=figure('name', 'The Temporally Filtered Movie','numbertitle','off');
        set(mydata.hf,'userdata',moviedata);
    else
        figure(moviedata.playtsfigure);
        set(moviedata.playtsfigure,'name', 'The Temporally Filtered Movie','numbertitle','off');
    end
    %if max(max(max(x)))~=0
    %    x=x/max(max(max(x)));
    %end         
    for i=1:size(x,3)
        if i>1&get(mydata.h_pause,'value')==1
            waitforbuttonpress;
        end
        figure(moviedata.playtsfigure)
        imshow(x(:,:,i));
    end
    if get(mydata.h_pause,'value')==1
        waitforbuttonpress; 
        close(moviedata.playtsfigure);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PolarAll%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%similar to the previous function, polarall plots all frames of the movie
%on the same set of axes at once.
function polarall(cbo, eventdata,mydata)
    moviedata=get(mydata.hf,'userdata');
    thresh=moviedata.thresh;
    thet=moviedata.thet;
    radi=moviedata.radi;
    count=1;
    figure('name','Polar Plot','numbertitle','off','menubar', 'none');
    polar(thet(:),radi(:),'.k');
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot3D%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot3d(cbo,eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
mov=moviedata.radi;
hf=figure('name','Output Intensities','numbertitle','off');
ax=gca;
%axis([0 size(mov,2) 0 size(mov,1) 0 max(max(max(mov)))])
axis([0 size(mov,2) 0 size(mov,1) 0 min(size(mov,2),size(mov,1))])
%axis manual
axis ij
axis equal
axis off
hold on
%rescale:
%zmax=round(max(mov(:)));
%mov=mov/zmax*min(size(mov,2),size(mov,1));
if moviedata.scaling==1
    zmax=round(max(mov(:)));
    omax=zmax;
else
    zmax=moviedata.scaling;
    omax=round(max(mov(:)));
end
mov=mov/zmax*min(size(mov,2),size(mov,1));
h_scale=uicontrol(hf,'style','text',...
    'string','Press a key to advance frames.',...
    'position',[110 380 90 40]);

for i = 2:size(mov,3)
    if gcf==hf
        try
            cf=surf(ax,mov(:,:,i));
            set(hf,'name',['Max z-axis = ' num2str(zmax) '(rescaled from ' ...
                num2str(omax) ')' ' Frame:  ',num2str(i)]);
            colormap gray
            shading interp
           
        catch
            try  
                close(hf)
            end
            return
        end
        te=0;
        while te==0&gcf==hf 
            te=waitforbuttonpress;
        end
        try
            set(cf,'visible','off');
        end
    else
        try
                close(hf)
        end
    end
end
try
    close(hf)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot 3d Mean%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotmean(cbo,eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
mov=moviedata.radi;
hf=figure('name','Output Intensities','numbertitle','off');
ax=gca;
mov=mean(mov,3);
axis([0 size(mov,2) 0 size(mov,1) 0 min(size(mov,2),size(mov,1))])
axis ij
axis equal
axis off
hold on
%rescale:
zmax=round(max(mov(:)));
mov=mov/zmax*min(size(mov,2),size(mov,1));
surf(ax,mov);
set(hf,'name',['Max z-axis = ' num2str(zmax) ]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%save3D%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save3d(cbo,eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
[datafile datapath filterindex]=uiputfile({'*.avi;*.wmv',...
            'Movie Files'},'Save As');
if datafile
mov=moviedata.radi;
hf=figure('name','Output Intensities','numbertitle','off');
%h_scale=uicontrol(hf,'style','text',...
%    'string','values scaled by 10^4',...
%    'position',[110 380 90 40]);
ax=gca;
%axis([0 size(mov,2) 0 size(mov,1) 0 max(max(max(mov)))])
%axis manual
axis([0 size(mov,2) 0 size(mov,1) 0 min(size(mov,2),size(mov,1))])
%axis manual
axis ij
axis equal
axis off
hold on
%rescale
%if moviedata.scaling==1
%    zmax=round(max(mov(:)));
%else
%    zmax=moviedata.scaling;
%end
if moviedata.scaling==1
    zmax=round(max(mov(:)));
    omax=zmax;
else
    zmax=moviedata.scaling;
    omax=round(max(mov(:)));
end
mov=mov/zmax*min(size(mov,2),size(mov,1));

%if moviedata.scaling==1
%    mov=mov/max(abs(mov(:)))*min(size(mov,2),size(mov,1));
%else
%    mov=mov/moviedata.scaling
%end
%set(hf,'position',[55 121 1010 753]);
for i = 2:size(mov,3)
        try
            %cf=surf(ax,mov(:,:,i));
            %colormap pink
            %shading interp
            %set(hf,'name',['Frame:  ',num2str(i)]);
            %g(i-1)=getframe(hf);
            cf=surfl(ax,mov(:,:,i));
            set(hf,'name',['Max z-axis = ' num2str(zmax) '(rescaled from ' ...
                num2str(omax) ')' ' Frame:  ',num2str(i)]);
            colormap pink
            %shading interp
            drawnow
            g(i-1)=getframe(hf);
        catch
            try  
                close(hf)
            end
            errordlg(['Could not save file:  ',lasterr],'Cannot Save');
            return
        end

        set(cf,'visible','off');

end
try
    close(hf)
    drawnow
end

   try
      movie2avi(g, [datapath datafile], 'compression','none','fps', 10);
   catch
      errordlg(['Access is denied: file may be in use:  ',lasterr]); 
   end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PlotColor%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotcolor(cbo, eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
%if size(moviedata.mov(:),1)>2000000
if size(moviedata.mov(:),1)>13000000
    errordlg(['Movie is too large; Please resize or crop the ',...
    'movie before continuing.  Maxium size is 6,000,000 pixels.',...
    'The movie is currently ',num2str(size(moviedata.mov(:),1)),...
    ' pixels'],'Not Enough Memory');
else

set(mydata.h_busy,'visible','on');
drawnow
szi=size(moviedata.mov,1);% size of images
szj=size(moviedata.mov,2);
ln=size(moviedata.mov,3);    
    Moxyc=zeros(szi,szj,3,ln);%initialize size 
temp=moviedata.thet;



    tempo1=Moxyc(:,:,1,:);
    tempo2=tempo1;
    tempo3=tempo1;  
    %blue
    tempo3(find((temp>=-pi/8&temp<=0)|(temp<pi/8&temp>=0)))=1;
    %green
    tempo2(find((temp>pi/8&temp<=3*pi/8)))=1;
    %yellow
    tempo1(find(temp>3*pi/8&temp<=5*pi/8))=1;
    tempo2(find(temp>3*pi/8&temp<=5*pi/8))=1;
    %orange
    tempo1(find(temp>5*pi/8&temp<=7*pi/8))=1;
    tempo2(find(temp>5*pi/8&temp<=7*pi/8))=140/255;
    %red
    tempo1(find((temp>7*pi/8&temp<=pi)|(temp<-7*pi/8&temp>=-pi)))=1;
    %mag
    tempo1(find(temp<-5*pi/8&temp>=-7*pi/8))=1;
    tempo2(find(temp<-5*pi/8&temp>=-7*pi/8))=20/255;
    tempo3(find(temp<-5*pi/8&temp>=-7*pi/8))=157/255;
    %purp
    tempo1(find(temp<-3*pi/8&temp>=-5*pi/8))=208/255;
    tempo2(find(temp<-3*pi/8&temp>=-5*pi/8))=32/255;
    tempo3(find(temp<-3*pi/8&temp>=-5*pi/8))=144/255;
    %vio
    tempo1(find(temp<-pi/8&temp>=-3*pi/8))=138/255;
    tempo2(find(temp<-pi/8&temp>=-3*pi/8))=43/255;
    tempo3(find(temp<-pi/8&temp>=-3*pi/8))=226/255;

    Moxyc(:,:,1,:)=tempo1;
    Moxyc(:,:,2,:)=tempo2;
    Moxyc(:,:,3,:)=tempo3;

    
%Moxyc=Moxyc./255;%rescale to [0,1]
%SCALE OUTPUT COLORS BASED ON INTENSITY(Moxy)

if moviedata.scaling<=2
    maxa=max(max(max(moviedata.radi)))*moviedata.scaling;
else
    maxa=moviedata.scaling;
end

if maxa==0
    maxa=1;
end

xx(:,:,1,:)=moviedata.radi/maxa;
Moxyc(:,:,1,:)=Moxyc(:,:,1,:).*xx;
Moxyc(:,:,2,:)=Moxyc(:,:,2,:).*xx;
Moxyc(:,:,3,:)=Moxyc(:,:,3,:).*xx;
moviedata.movm=Moxyc;

set(mydata.hf,'userdata',moviedata);
set(mydata.h_playmot,'visible','on');
set(mydata.h_busy,'visible','off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PolarFrame%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%displays each frame of the movie side by side with the polar plot of the 
%intensity and angles derived from the detectmotion function.
%if the frame by frame checkbox is enabled(get(mydata.h_pause,'value')==1)
%then the user must click the plot before he next frame is displayed
%otherwise, there is a 0.5 second pause between frames
function polarframe(cbo, eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
thet=moviedata.thet;
radi=moviedata.radi;
h2=figure('name','Motion Detected','numbertitle','off');
h1=figure('name','Polar Plot','numbertitle','off','menubar', 'none');
hpa=polar(pi,max(max(max(radi))));
axe=gca;
hold on;
set(hpa,'visible','off');
for i=1:size(radi,3)
    %figure(h1)
    hpa=polar(axe,thet(:,:,i),radi(:,:,i),'.k');
    hold on;
    set(h1,'name',['Polar Plot, frame:  ',num2str(i)]);
    try
        figure(h2)
        imshow(moviedata.movm(:,:,:,i));
    catch
        %if max(max(max(moviedata.mov)))~=0
        %    x=max(max(max(moviedata.mov)));
       %end
        imshow(moviedata.mov(:,:,i));
        set(h2,'name',['Movie frame:  ',num2str(i)]);
    end
    
    
    %figure(h2)
    %imshow(moviedata.movm(:,:,:,i));
    if get(mydata.h_pause, 'value')==1
        waitforbuttonpress;
    else
        pause(0.5)
    end
    set(hpa,'visible','off');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SavePolar%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%displays each frame of the movie side by side with the polar plot of the 
%intensity and angles derived from the detectmotion function.
%if the frame by frame checkbox is enabled(get(mydata.h_pause,'value')==1)
%then the user must click the plot before he next frame is displayed
%otherwise, there is a 0.5 second pause between frames
function savepolar(cbo, eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
thet=moviedata.thet;
radi=moviedata.radi;
h1=figure('name','Polar Plot','numbertitle','off','menubar', 'none');
hpa=polar(pi,max(max(max(radi))));
axe=gca;
hold on;
h_scale=uicontrol(h1,'style','text',...
    'string','values scaled by 10^4',...
    'position',[140 350 90 40]);
set(hpa,'visible','off');
for i=1:size(radi,3)
    hpa=polar(axe,thet(:,:,i),radi(:,:,i),'.k');
    hold on
    g(i)=getframe;
    set(hpa,'visible','off');
end
[datafile datapath filterindex]=uiputfile({'*.avi;*.wmv',...
            'Movie Files'},'Save As');
if datafile
   try
      movie2avi(g, [datapath datafile], 'compression','none','fps', 10);
   catch
      errordlg(['Access is denied: file may be in use:  ',lasterr]); 
   end 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ResizeMovie%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%reduces the size of each frame of the movie by rsvalue, a number between 
%0 and 1.  A confirmation box appears showing the first frame of the movie
%in its new size.
function resizemovie(cbo, eventdata, mydata, rsvalue)
    if nargin<4
        rsvalue=0;
       while isempty(rsvalue)|rsvalue<=0|rsvalue>5
        answer = inputdlg(['Enter a value between 0 and 5 in decimal ',...
            'or fraction notation'], 'Enter Resize Factor');
        if isempty(answer)
            return
        end
        [a b]=strtok(answer{1},'/');
        if isempty(b)
            try
                rsvalue=str2num(a);
            catch
                rsvalue=0;
            end
        else
            rsvalue=str2num(a)/str2num(strtok(b,'/'));
        end

       end%end while
    end
      
    moviedata=get(mydata.hf,'userdata');
    temp=moviedata.mov(:,:,1);
    temp=imresize(temp,rsvalue);
    hr=figure('name', 'Resize?','numbertitle', 'off');
    %if max(max(temp))~=0
    %    temp=temp/max(max(temp));
    %end
    imshow(temp);
    answer=questdlg('Really resize?','Resize Movie?','Yes','No','No');
        if strcmp(answer,'Yes')
            moviedata.oldmov=moviedata.mov;
            set(mydata.h_undo,'enable','on');
            moviedata.mov=imresize(moviedata.mov,rsvalue);
            set(mydata.hf,'userdata',moviedata);
        end
        close(hr);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SaveFile%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%writes the selected movie as an uncompressed avi file at a speed of 10fps
function savefile(cbo, eventdata,mydata,movietype)
moviedata=get(mydata.hf,'userdata');
if isequal(movietype, 'movie')
    mov=moviedata.mov;
else
    mov=moviedata.movm;
end
datafile=0;
[datafile datapath filterindex]=uiputfile({'*.avi;*.wmv','Movie Files'},...
    'Save As');
if ~isequal(datafile,0)
  %[b,r]=strtok(datafile,'.');
 if length(size(mov))==4
    for i = 1:size(mov,4)
        m(i)=im2frame(mov(:,:,:,i));
    end
 else
    tempa=zeros(size(mov,1),size(mov,2),3);
    for i = 1:size(mov,3)
            tempa(:,:,1)=mov(:,:,i);
            tempa(:,:,2)=mov(:,:,i);
            tempa(:,:,3)=mov(:,:,i);
            m(i)=im2frame(tempa/255); 
    end
 end
 %%experimental
 v.frames=m;
 v.height=size(mov,1);
 v.width=size(mov,2);
 try
    movie2avi(m, [datapath datafile], 'compression','none','fps', 30);
 catch
    errordlg(['Access is denied: file may be in use:  ',lasterr]); 
 end  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SaveMatrix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savematrix(cbo, eventdata, mydata)
moviedata=get(mydata.hf,'userdata');
savestruct.mov=moviedata.mov;
savestruct.mx=moviedata.mx;
savestruct.my=moviedata.my;
savestruct.radi=moviedata.radi/10000;%rescale to original values
savestruct.thet=moviedata.thet;
try
    savestruct.movm=moviedata.movm;
end
[datafile datapath]=uiputfile({'*.MAT'},'Save As');
if datafile
    save([datapath datafile],'savestruct');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SaveRaw%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%added 2/19/2014 to allow reading raw data without matlab
function saverawxl(cbo, eventdata, mydata,mag)
moviedata=get(mydata.hf,'userdata');
if mag==1
    s=moviedata.radi/10000;
else
    s=moviedata.thet;
end
[datafile datapath]=uiputfile({'*.xls;*.xl','Excel Spreadsheet'});
warning('off');
try
    set(mydata.h_busy,'visible','on');
    drawnow;
for i = 1:size(s,3)
    xlswrite([datapath datafile],s(:,:,i),i)
end
catch
     errordlg(lasterr)
end
set(mydata.h_busy,'visible','off');
warning('on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SaveXL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savexl(cbo, eventdata, mydata)
moviedata=get(mydata.hf,'userdata');
radi=moviedata.radi/10000;
[datafile datapath]=uiputfile({'*.xls;*.xl','Excel Spreadsheet'});
for i = 1:size(radi,3)
    x(i)=max(max(radi(:,:,i)));
end
mname=inputdlg('Enter Name for Movie','Movie Name');
if isempty(mname)
    return
end
warning('off');
[success, error]=xlswrite([datapath datafile],x,mname{1},'B2');
[success,error]=xlswrite([datapath datafile],1:size(radi,3),mname{1},'B1');
[success,error]=xlswrite([datapath datafile],mname,mname{1},'A2');
warning('on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%scalingcallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scalingcallback(cbo, eventdata, mydata)

if str2num(get(cbo,'string'))>0&str2num(get(cbo,'string'))<4000
    moviedata=get(mydata.hf, 'userdata');
    moviedata.scaling=str2num(get(cbo,'string'));
    set(mydata.hf, 'userdata',moviedata);
else
      errordlg('You must enter a value between 0 and 4000','Invalid Entry');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%seditcallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the sedit box.  Ensures the value entered into the box is
%appropriate fot the spacing parameter and then updates the sslider and the
%value of spacing in the moviedata structure.
function seditcallback(cbo, eventdata, mydata)

if str2num(get(cbo,'string'))<=get(mydata.h_sslider,'max')&...
        str2num(get(cbo,'string'))>=get(mydata.h_sslider,'min')
    moviedata=get(mydata.hf,'userdata');
    set(mydata.h_sslider,'value',str2num(get(cbo,'string')));
    moviedata.spacing=round(str2num(get(cbo,'string')));
    %test
    moviedata.stdv1=round(moviedata.spacing*.5);
    moviedata.stdv2=round(moviedata.spacing*.8);
    set(mydata.h_stdv1,'string',num2str(round(moviedata.spacing*.5)));
    set(mydata.h_stdv2,'string',num2str(round(moviedata.spacing*.8)));
    set(mydata.hf, 'userdata', moviedata);
else
    set(cbo,'string',sprintf('%d',round(get(mydata.h_sslider,'value'))));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sslidercallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the sslider bar.  Updates the value of the spacing field of
%the moviedata structure.
function sslidercallback(cbo, eventdata, mydata)
moviedata=get(mydata.hf,'userdata');
 moviedata.spacing=round(get(cbo,'value'));
 set(mydata.h_scur,'string',sprintf('%d',round(get(cbo,'value'))));
 moviedata.stdv1=round(moviedata.spacing*.5);
    moviedata.stdv2=round(moviedata.spacing*.8);
    set(mydata.h_stdv1,'string',num2str(round(moviedata.spacing*.5)));
    set(mydata.h_stdv2,'string',num2str(round(moviedata.spacing*.8)));
 set(mydata.hf, 'userdata',moviedata);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%stdv1callback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the stdv1 edit box.  Updates the stdv1 field of the moviedata
%structure only if the value entered is a number between 0 and 30.
function stdv1callback(cbo, eventdata,mydata)
if str2num(get(cbo,'string'))>0&str2num(get(cbo,'string'))<30
    moviedata=get(mydata.hf, 'userdata');
    moviedata.stdv1=round(str2num(get(cbo,'string')));
    set(mydata.hf, 'userdata',moviedata);
else
      errordlg('You must enter a value between 0 and 30','Invalid Entry');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%stdv2callback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the stdv2 edit box.  Updates the stdv2 field of the moviedata
%structure only if the value entered is a number between 0 and 60.

function stdv2callback(cbo, eventdata,mydata)
if str2num(get(cbo,'string'))>0&str2num(get(cbo,'string'))<60
    moviedata=get(mydata.hf, 'userdata');
    moviedata.stdv2=round(str2num(get(cbo,'string')));
    set(mydata.hf, 'userdata',moviedata);
else
      errordlg('You must enter a value between 0 and 60','Invalid Entry');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%teditcallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the tedit box.  Ensures that the value entered is within
%appropriate values, updates the slider object and updates the t value
%within the moviedata structure.
function teditcallback(cbo, eventdata, mydata)

if str2num(get(cbo,'string'))<=get(mydata.h_tslider,'max')&...
        str2num(get(cbo,'string'))>=get(mydata.h_tslider,'min')
    moviedata=get(mydata.hf,'userdata');
    set(mydata.h_tslider,'value',str2num(get(cbo,'string')));
    moviedata.t=str2num(get(cbo,'string'));
    set(mydata.hf, 'userdata', moviedata);
else
    set(cbo,'string',sprintf('%.3g',get(mydata.h_tslider,'value')));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%tslidercallback%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%callback for the tau slider object.  Updates the value of t in the
%moviedata struture.
function tslidercallback(cbo, eventdata, mydata)
 moviedata=get(mydata.hf,'userdata');
 moviedata.t=get(cbo,'value');
 set(mydata.h_tcur,'string',sprintf('%.3g',get(cbo,'value'))); 
 set(mydata.hf, 'userdata',moviedata);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Undo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%undoes the last resize or crop
function undo(cbo,eventdata,mydata)
moviedata=get(mydata.hf,'userdata');
moviedata.mov=moviedata.oldmov;
moviedata.oldmov=0;
set(cbo,'enable','off');
set(mydata.hf,'userdata',moviedata);






