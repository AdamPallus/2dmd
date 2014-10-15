function Output=detectmotion2(im,spacing,t,gsize,stdv1,stdv2)
%Use: Output=detectmotion2(Movie,spacing,t,gsize,stdv1,stdv2)
%Fixed: 6-17-08 removed excessive copies of matrices

if nargin<6
   stdv2=8;
   if nargin<5
    stdv1=4;
    if nargin<4
      gsize=25;
      if nargin<3
       t=2;
       if nargin<2
          spacing=2;
       end
      end
    end
   end
end
if ~strcmp(class(im),'double')
    im=double(im);
end
[im,imlpf]=mfilter(im,t,gsize,stdv1,stdv2);
szi=size(im,1);% size of images
szj=size(im,2);
ln=size(im,3); % length:  number of frames
%initialize variables
%Moxy=zeros(szi,szj,ln);
%Mox=Moxy;%motion in x direction
%Moy=Moxy;% motion in y direction


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%DETECT MOTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%each pixel in each frame is compared with a pixel SPACING spaces away in 
%the temporally filtered version.
%x1= im;
%x2= imlpf;
%offset the matrices by spacing pixels, filling in 0s.  This causes motion 
%on the edges to be calculated inaccurately for greater values of SPACING
%there are seperate matrices for X and Y directional offsets, corresponding
%to the X and Y directional set of elementary motion detectors
%y1x=[zeros(size(im,1),spacing,ln),im(:,1:size(im,2)-spacing,:)];
%y1y=[zeros(spacing,size(im,2),ln);im(1:size(im,1)-spacing,:,:)];
%y2x=[zeros(size(imlpf,1),spacing,ln),imlpf(:,1:size(imlpf,2)-spacing,:)];
%y2y=[zeros(spacing,size(imlpf,2),ln);imlpf(1:size(imlpf,1)-spacing,:,:)];      
%multiply the intensities of the pixels  and subtract outputs from each
%direction.  This is where the motion is detected.
%m1x=x2.*y1x;m2x=x1.*y2x; 
%m1y=x2.*y1y;m2y=x1.*y2y;   

%Mox=m1x-m2x;
%Moy=m1y-m2y;
 x=(imlpf.*[zeros(size(im,1),spacing,ln),im(:,1:size(im,2)-spacing,:)]- ...
     im.*[zeros(size(imlpf,1),spacing,ln),imlpf(:,1:size(imlpf,2)-spacing,:)])*-1;
 y=imlpf.*[zeros(spacing,size(im,2),ln);im(1:size(im,1)-spacing,:,:)]-...
     im.*[zeros(spacing,size(imlpf,2),ln);imlpf(1:size(imlpf,1)-spacing,:,:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%CALCULATE ANGLE AND MAGNITUDE%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x=-Mox;%x is negated to create regular axis direction -->+
%y=Moy;%positive indicates upward motion
Moxy=sqrt(x.^2+y.^2);
temp=atan2(y,x);

outputstruct.radi=Moxy; clear moxy
outputstruct.thet=temp; clear temp
outputstruct.sfilter=im; clear im
outputstruct.tsfilter=imlpf; clear imlpf
%outputstruct.mx=Mox; clear Mox
%outputstruct.my=Moy; clear Moy
%outputstruct.impf=im(:,:,:); clear im
%outputstruct.impf=outputstruct.sfilter(:,:,:); clear im

%outputstruct.implpf=imlpf(:,:,:); clear imlpf
%outputstruct.implpf=; clear imlpf
%outputstruct.implpf=Mox(:,:,:); 
%outputstruct.y1x=y1x; clear y1x
%outputstruct.y2x=y2x; clear y2x
Output=outputstruct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%FILTER FUNCTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [image,image2] = mfilter(M, t,gsize,sdv,sdv2 )
%mfilter filters movie files
% returns a spacially filtered version
% and both spacially and temporally filtered version
if nargin==1
  t=2;
end
if nargin<3
    gsize=25;
end
if nargin<5
    sdv=4;
    sdv2=8;
end

Bex=fspecial('gaussian', gsize,sdv);
Bin=fspecial('gaussian',gsize ,sdv2);
B1=Bex-Bin;
M1=imfilter(M,B1,'replicate');
%for i=1:size(M,3)
%       M1(:,:,i)=filter2(B1,double(M(:,:,i)));
%end
M1t=filter([0,1]/t,[1, -(t-1)/t], double(M1), [], 3);
image=M1;
image2=M1t;
