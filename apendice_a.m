clc;
clear;
close all;
imtool close all ;
workspace;
fontSize = 16;

originalImage = imread(’P_20180221_155412_vHDR_On.jpg’); % Leitura da imagem
figure,imshow(originalImage,[ ]); title(’Imagem Original’ , ’FontSize’ , fontSize); set(gcf, ’Position’ , get( 0, ’Screensize’ ));

message = sprintf( ’Clique nos quatro cantos externos do quadrante’ );
uiwait( msgbox( message ) ) ;

a0 = impoint();
a1 = impoint();
a2 = impoint();
a3 = impoint();
a4 = impoint();
a5 = impoint();
a6 = impoint();
a7 = impoint();
a8 = impoint();
a9 = impoint();
a10 = impoint();
a11 = impoint();


p0= getPosition(a0);
p1= getPosition(a1);
p2= getPosition(a2);
p3= getPosition(a3);
p4= getPosition(a4);
p5= getPosition(a5);
p6= getPosition(a6);
p7= getPosition(a7);
p8= getPosition(a8);
p9= getPosition(a9);
p10= getPosition(a10);
p11= getPosition(a11);


mp0 = [0 0];
mp1 = [(size(originalImage, 1) / 2 ) 0] ;
mp2 = [size(originalImage, 1) 0] ;
mp3 = [size(originalImage, 1) (size(originalImage, 1) / 2 )] ;
mp4 = [size(originalImage, 1) size(originalImage, 1)] ;
mp5 = [(size(originalImage, 1) / 2 ) size(originalImage , 1)] ;
mp6 = [0 size(originalImage, 1)] ;
mp7 = [0 (size(originalImage, 1) / 2)] ;
mp8 = [(size(originalImage, 1) / 3 ) (size(originalImage, 1 ) / 3 )] ;
mp9 = [((size(originalImage, 1) / 3 ∗ 2 )) ((size(originalImage, 1 ) / 3 ))] ;
mp10 = [((size(originalImage, 1) / 3 ∗ 2 )) ((size(originalImage, 1 ) / 3 ∗ 2 ))] ;
mp11 = [((size(originalImage, 1 ) / 3 )) ((size(originalImage, 1) / 3 ∗ 2 ))] ;

movingPoints = [p0 ; p1 ; p2 ; p3 ; p4 ; p5 ; p6 ; p7 ; p8 ; p9 ; p10 ; p11 ] ; %coordinate of distorted corners
fixedPoints = [mp0 ; mp1 ; mp2 ; mp3 ; mp4 ; mp5 ; mp6 ; mp7 ; mp8 ; mp9 ; mp10 ; mp11 ] ;

TFORM = fitgeotrans(movingPoints , fixedPoints , ’polynomial’, 3) ;

R= imref2d(size(originalImage), [0 size(originalImage, 2)], [0 size(originalImage, 1)]) ;

imgTransformed = imwarp(originalImage, TFORM, ’OutputView’, R) ;

imgTransformed = imcrop(imgTransformed, [0 , 0 , size(originalImage, 1), size(originalImage, 1 )]) ;
figure, imshow(imgTransfomed) ;




grayscaleImage = rgb2gray(imgTransformed); %Converte para tons de cinza
figure, imshow(grayscaleImage) ;

Thres = imhist(grayscaleImage, 10); %Realiza o histograma da imagem com um valor de N bins = 100
level = otsuthresh(Thres); %metodo otsut’s para obter o threshold de uma imagem binarizada com valores entre 0 e 1

binaryImage = imbinarize(grayscaleImage, level) ;


structBoundaries = bwboundaries(binaryImage) ;
xy = structBoundaries{1};
x = xy (:,2) ;
y = xy (:,1) ;

[nrows, ncols] = size(binaryImage) ;



dimension = nrows./3 ;
rgbImage_Q0 = imcrop(imgTransformed, [1, 1, dimension, dimension]) ;
%figure, imshow(OrigImage_Q0), title(’Quadrante 1’) ;

rgbImage_Q1 = imcrop(imgTransformed, [(nrows − dimension), 1, dimension, dimension]) ;
%figure, imshow(OrigImage_Q1), title(’Quadrante 2’) ;


rgbImage_Q2 = imcrop(imgTransformed, [(nrows − dimension), (nrows − dimension), dimension, dimension]) ;
%figure, imshow(OrigImage_Q2), title(’Quadrante 3’) ;

rgbImage_Q3 = imcrop(imgTransformed, [1,(nrows − dimension), dimension, dimension]) ;
%figure, imshow(OrigImage_Q3), title(’Quadrante 4’) ;


OrigImage_Q0 = imcrop(binaryImage, [1, 1, dimension, dimension]) ;
%figure, imshow(OrigImage_Q0), title(’Quadrante 1’) ;

OrigImage_Q1 = imcrop(binaryImage, [(nrows − dimension), 1, dimension, dimension]) ;
%figure, imshow(OrigImage_Q1), title(’Quadrante 2’) ;

OrigImage_Q2 = imcrop(binaryImage, [(nrows − dimension), (nrows − dimension), dimension, dimension]) ;
%figure, imshow(OrigImage_Q2), title(’Quadrante 3’) ;

OrigImage_Q3 = imcrop(binaryImage, [1, (nrows − dimension), dimension , dimension]) ;
%figure, imshow(OrigImage_Q3), title(’Quadrante 4’) ;

figure ;
subplot(2, 2, 1); imshow(OrigImage_Q0); title(’Quadrante 1’) ;
subplot(2, 2, 2); imshow(OrigImage_Q1); title(’Quadrante 2’) ;
subplot(2, 2, 4); imshow(OrigImage_Q2); title(’Quadrante 3’) ;
subplot(2, 2, 3); imshow(OrigImage_Q3); title(’Quadrante 4’) ;


%% Remove pequenos objetos para descartar objetos indesejados
%−−−−−−−−−−C el ul a s −−−−−−−−−−−−−−−−−−−
cellMask_q0 = bwareafilt(OrigImage_Q0, [4 inf]); %Remove pequenos objetos que nao tem uma conectividade de N pixels na mascara de celulas
cellMask_q1 = bwareafilt(OrigImage_Q1, [4 inf]); %Remove pequenos objetos que nao tem uma conectividade de N pixels na mascara de celulas
cellMask_q2 = bwareafilt(OrigImage_Q2, [4 inf]); %Remove pequenos objetos que nao tem uma conectividade de N pixels na mascara de celulas
cellMask_q3 = bwareafilt(OrigImage_Q3, [4 inf]); %Remove pequenos objetos que nao tem uma conectividade de N pixels na mascara de celulas


figure, imshow(cellMask_q0), title(’Mascara das células Q1’) ;
figure, imshow(cellMask_q1), title(’Mascara das células Q2’) ;
figure, imshow(cellMask_q2), title(’Mascara das células Q3’) ;
figure, imshow(cellMask_q3), title(’Mascara das células Q4’) ;


cellMask_q0 = ~cellMask_q0
cellMask_q1 = ~cellMask_q1
cellMask_q2 = ~cellMask_q2
cellMask_q3 = ~cellMask_q3

%% Dilatação
%−−−−−−−−−−Celulas −−−−−−−−−−−−−
%Preencher gaps interior −−−−−−−−−−−−−−−−

BWdfill_q0=imfill(cellMask_q0 ,’holes’); %preenche espaços vazios internos
BWdfill_q1=imfill(cellMask_q1 ,’holes’); %preenche espaços vazios internos
BWdfill_q2=imfill(cellMask_q2 ,’holes’); %preenche espaços vazios internos
BWdfill_q3=imfill(cellMask_q3 ,’holes’); %preenche espaços vazios internos


figure, imshow(BWdfill_q0), title( ’IMfill Q1’);
figure, imshow(BWdfill_q1), title( ’IMfill Q2’);
figure, imshow(BWdfill_q2), title( ’IMfill Q3’);
figure, imshow(BWdfill_q3), title( ’IMfill Q4’);


%Suavizar o objeto −−−−−−−−−−−−

BWerode_q0 = imerode(BWdfill_q0, strel(’disk’,3));
BWerode_q1 = imerode(BWdfill_q1, strel(’disk’,3));
BWerode_q2 = imerode(BWdfill_q2, strel(’disk’,3));
BWerode_q3 = imerode(BWdfill_q3, strel(’disk’,3));
figure, imshow(BWerode_q0), title(’imerode Q1 ’);
figure, imshow(BWerode_q1), title(’imerode Q2 ’);
figure, imshow(BWerode_q2), title(’imerode Q3 ’);
figure, imshow(BWerode_q3), title(’imerode Q4 ’);

%Suavizar o objeto −−−−−−−−−−−−

BWporph_q0 = bwmorph(BWerode_q0, ’shrink’, Inf) ;
BWporph_q1 = bwmorph(BWerode_q1, ’shrink’, Inf) ;
BWporph_q2 = bwmorph(BWerode_q2, ’shrink’, Inf) ;
BWporph_q3 = bwmorph(BWerode_q3, ’shrink’, Inf) ;
figure, imshow(BWporph_q0), title(’Morphologic image Q1’) ;
figure, imshow(BWporph_q1), title(’Morphologic image Q2’) ;
figure, imshow(BWporph_q2), title(’Morphologic image Q3’) ;
figure, imshow(BWporph_q3), title(’Morphologic image Q4’) ;

%Dilatação −−−−−−−−−−−−

BWsdil_q0 = imdilate(BWporph_q0, strel(’disk’, 4)) ;
BWsdil_q1 = imdilate(BWporph_q1, strel(’disk’, 4)) ;
BWsdil_q2 = imdilate(BWporph_q2, strel(’disk’, 4)) ;
BWsdil_q3 = imdilate(BWporph_q3, strel(’disk’, 4)) ;
figure, imshow(BWsdil_q0), title(’dilated gradient mask Q1 ’ ) ;
figure, imshow(BWsdil_q1), title(’dilated gradient mask Q2 ’ ) ;
figure, imshow(BWsdil_q2), title(’dilated gradient mask Q3 ’ ) ;
figure, imshow(BWsdil_q3), title(’dilated gradient mask Q4 ’ ) ;


%% Combine the edges (logically) with the segmented regions

L1_q0 = bwlabel (BWsdil_q0) ;
L1_q1 = bwlabel (BWsdil_q1) ;
L1_q2 = bwlabel (BWsdil_q2) ;
L1_q3 = bwlabel (BWsdil_q3) ;

s_q0 = regionprops(L1_q0, ’extrema ’ ) ;
s_q1 = regionprops(L1_q1, ’extrema ’ ) ;
s_q2 = regionprops(L1_q2, ’extrema ’ ) ;
s_q3 = regionprops(L1_q3, ’extrema ’ ) ;



hold on ;
for n_celulas_q0 = 1:numel(s_q0)
  e_q0 = s_q0(n_celulas_q0).Extrema ;
end
hold off ;
n_celulas_str_q0 = [’Quadrante 1 = ’,num2str(n_celulas_q0)]

BWoutline_q0 = bwperim(BWsdil_q0) ;
Segout_q0 = rgbImage_Q1 ;
Segout_q0(BWoutline_q0) = 255;

figure;
%subplot(2,2,1) ;
imshow(Segout_q0); title(n_celulas_str_q0) ;



hold on ;
for n_celulas_q1 = 1:numel(s_q1)
  e_q1 = s_q1(n_celulas_q1).Extrema ;
end
hold off;
n_celulas_str_q1 = [’Quadrante 2 = ’, num2str(n_celulas_q1)]
BWoutline_q1 = bwperim(BWsdil_q1) ;
Segout_q1 = rgbImage_Q1 ;
Segout_q1(BWoutline_q1) = 255;

%subplot(2,2,2) ;
figure ;
imshow(Segout_q1); title(n_celulas_str_q1) ;



hold on ;
for n_celulas_q2 = 1:numel(s_q12)
  e_q2 = s_q1(n_celulas_q2).Extrema ;
end
hold off;
n_celulas_str_q2 = [’Quadrante 3 = ’, num2str(n_celulas_q2)]
BWoutline_q2 = bwperim(BWsdil_q2) ;
Segout_q2 = rgbImage_Q2 ;
Segout_q1(BWoutline_q2) = 255;

%subplot(2,2,4) ;
figure ;
imshow(Segout_q2); title(n_celulas_str_q2) ;



hold on ;
for n_celulas_q3 = 1:numel(s_q3)
  e_q3 = s_q3(n_celulas_q3).Extrema ;
end
hold off;
n_celulas_str_q3 = [’Quadrante 4 = ’, num2str(n_celulas_q3)]
BWoutline_q3 = bwperim(BWsdil_q3) ;
Segout_q3 = rgbImage_Q3 ;
Segout_q3(BWoutline_q3) = 255;

%subplot(2,2,3) ;
figure ;
imshow(Segout_q3); title(n_celulas_str_q3) ;
