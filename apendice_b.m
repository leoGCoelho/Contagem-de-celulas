clc;
clear;
close all;
workspace;
fontSize = 16;

originalImage = imread('celula.jpg'); %Leitura da imagem
img_exemplo = imread('celulaesp.jpg'); %imagem exemplo

figure , imshow(img_exemplo , []);
title('Imagem Exemplo', 'FontSize', fontSize);
set(gcf, 'Position', get(0, 'Screensize'));

message = sprintf('Clique nos pontos de referencia conforme imagem de exemplo apresentada');
uiwait (msgbox(message));

figure, imshow(originalImage, []);
title('Imagem Original', 'FontSize', fontSize);
set(gcf, 'Position', get(0, 'Screensize'));

a0 = impoint();
a1 = impoint();
a2 = impoint();
a3 = impoint();
a4 = impoint();
a5 = impoint();
a6 = impoint();
a7 = impoint();


p0=getPosition(a0);
p1=getPosition(a1);
p2=getPosition(a2);
p3=getPosition(a3);
p4=getPosition(a4);
p5=getPosition(a5);
p6=getPosition(a6);
p7=getPosition(a7);



mp0=[0 0];
mp1=[(size(originalImage,1)/2) 0];
mp2=[size(originalImage,1) 0];
mp3=[size(originalImage,1) (size(originalImage, 1)/2)];
mp4=[size(originalImage,1) size(originalImage, 1)];
mp5=[(size(originalImage,1)/2) size(originalImage, 1)];
mp6=[0 size(originalImage,1)];
mp7=[0 (size(originalImage,1)/2)];


movingPoints=[p0; p1; p2; p3; p4; p5; p6; p7];
fixedPoints=[mp0; mp1; mp2; mp3; mp4; mp5; mp6; mp7];
TFORM = fitgeotrans(movingPoints, fixedPoints,'polynomial', 2);

R=imref2d(size(originalImage),[0 size(originalImage,2)],[0 size(originalImage,1)]);

imgTransformed=imwarp(originalImage,TFORM,'OutputView',R);

imgTransformed = imcrop(imgTransformed,[0, 0, size(originalImage,1), size(originalImage,1)]);
%figure, imshow(imgTransformed);

ImageResized = imresize(imgTransformed,[655 655]);

%% Converte para tons de cinza
%Realiza a conversão da imagem original para escala de cinza
grayscaleImage = rgb2gray(ImageResized);
figure, imshow(grayscaleImage);%, title(’Tons de cinza’);

Thres = imhist(grayscaleImage, 10); %Realiza o histograma da imagem com um valor de N bins=100
level = otsuthresh(Thres); %metodo otsut’s para obter o threshold de uma imagem binarizada com valores entre 0 e 1

cellMask_q0 = imbinarize(grayscaleImage, level); %Binariza a imagem através de um threshold
figure, imshow(cellMask_q0), title('Segmentacao da imagem com tons de cinza');

%% Remove pequenos objetos para descartar objetos indesejados
% −−−−−−−−−−C e l u l a s −−−−−−−−−−−−−−−−−−−
cellMask_q0 = bwareafilt(cellMask_q0,[1 inf]); %Remove pequenos objetos que não tem uma conectividade de N pixels na mascara de celulas
figure, imshow(cellMask_q0), title('Mascara das celulas');

cellMask_q0 = -cellMask_q0

%% D i l a t a ç ã o
% −−−−−−−−−−C e l u l a s −−−−−−−−−−−−−
%Preencher gaps interior −−−−−−−−−−−−−−−−
BWdfill_q0 = imfill(cellMask_q0, 'holes'); %preenche espaços vazios internos

figure, imshow(BWdfill_q0), title('IMfill');


%Suavizar o objeto−−−−−−−−−−−−

BWerode_q0 = imerode(BWdfill_q0,strel('disk' , 3));

figure, imshow(BWerode_q0), title('imerode');


%Suavizar o objeto−−−−−−−−−−−−

BWporph_q0 = bwmorph(BWerode_q0, 'shrink', Inf);

figure, imshow(BWporph_q0), title('Morphologic image Q1');


%Dilatação−−−−−−−−−−−−

BWsdil_q0 = imdilate(BWporph_q0, strel('disk',4));

figure, imshow(BWsdil_q0), title('dilated gradient mask');



%%Combine the edges (logically) with the segmented regions

L1_q0 = bwlabel(BWsdil_q0);

figure, imshow(L1_q0); title('Edge');

s_q0 = regionprops(L1_q0, 'Extrema');

hold on;
for n_celulas_q0 = 1:numel(s_q0)
  e_q0 = s_q0(n_celulas_q0).Extrema;
  %text(e_q0(1, 1), e_q0(1, 2), sprintf(’%d ’, n_celulas_q0));
end
hold off;
n_celulas_str_q0 = ['numero de celulas = ', num2str(n_celulas_q0)]
Segout_q0 = ImageResized;
Segout_q0(BWsdil_q0) = 255;


figure;
imshow(Segout_q0); title(n_celulas_str_q0);
