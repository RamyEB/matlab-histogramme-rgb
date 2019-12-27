function ProjetRamy(im)
%But : On crée un tableau de 32x32x32 et on incremente de 1 la position 
%exemple avec un tab de 255 val: tab(100x34x255) = tab(100x34x255)+1
%On a donc pas besoin de créer un tab à 4 diemensions
%(R,G,B,incrementation) car les position sont les vaeuleurs : 
% Pour : 100x34x255 
%R=100 
%G=34 
%B=255
%A cette position il y a 3 pixel de cette couleur
%donc scatter3(100,34,255,tab(100x34x255));


%Nombre maximum du degrès de couleur 255 devient 32
ngrid = 32;
%Valeur maximum en couleur de l'image
maxval = double(intmax(class(im))); %class=utf-8 et intmax() soit la plus grde valeur
%Par combien divisé 256 pour obtenir 32 donc 8
valstep = (maxval+1)/ngrid;

[M,N,~] = size(im);
%% count

%Tableau de 0 cnt(32,32,32)
cnt = zeros(ngrid,ngrid,ngrid);
maxcnt = -inf;
%On parcours l'image
for i = 1:M
    for j = 1:N
        %On mets à 32 les valeurs des couleurs 
        indexR = floor(double(im(i,j,1))/valstep)+1;
        indexG = floor(double(im(i,j,2))/valstep)+1;
        indexB = floor(double(im(i,j,3))/valstep)+1;
        %On incremente la couleur/position
        cnt(indexR,indexG,indexB) = cnt(indexR,indexG,indexB)+1;
        %Maxcnt est le plus gros nombre de pixel de la meme couleur dans l'image 
        if cnt(indexR,indexG,indexB) > maxcnt
            maxcnt = cnt(indexR,indexG,indexB);
        end
    end
end


%% Les plot
%La fonction figure() modifier les parametre de la fenetre
%Name : modifie le nom de la fenetre
%numbertitle : affiche ou non le numéro du projet (exemple : "Projet 1 :")
%color : modifie la couleur de fond en prenant des valeur de 0 à 1 en RGB
fenetre = figure('name','Projet Ramy | Histogramme de couleur','numbertitle','off','color',[0.8 0.8 0.8]);
%Permet de créer un repère dans la fenetre h_f
repere = axes('parent',fenetre);

%Permet une image en 3D
set(repere,'box','on','projection','perspective','dataaspectratio',[1 1 1])
%Permet de fixer une limite à 300 (pour afficher correctement les spheres
%en coin
set(repere,'xlim',[0 maxval+50],'ylim',[0 maxval+50],'zlim',[0 maxval+50])
%permet d'afficher un cadrillage
set(repere,'xgrid','on','ygrid','on','zgrid','on')

    %la fonction sphere créer un modèle de sphere (16 est sa dimension en nombre de faces)
    %Elle sera donc plus ou moins bien définie en fonction de sont nb faces
    %[sphereX,sphereY,sphereZ] = est la position de la sphere
    %Les est centrée à l'origine à l'initialisation
    [sphereX,sphereY,sphereZ] = sphere(16);
    %ngrid=32 comme défini plus haut
    for i = 1:ngrid
        for j = 1:ngrid
            for k = 1:ngrid
                %valstep : est la valeur qui divise 256 pour obtenir 32
                %donc 8 car 256/32

                %Ici on remets les positions des sphere à 255
                cx = i*valstep-1;
                cy = j*valstep-1;
                cz = k*valstep-1;
                
                
                %cnt = Tableau de referencement des couleur (histogramme)
                %On dit donc is que si il y'a au moins 1 pixel dans notre
                %histogramme 
                if cnt(i,j,k) > 0
                    nbPixel = cnt(i,j,k);
                    %*nbPixel gère la taille de la sphere
                    %+c.. gère l'emplacement de la sphère
                    %facecolor modifie la couleur de la surface
                    surface((nbPixel/500)*sphereX+cx,(nbPixel/500)*sphereY+cy,(nbPixel/500)*sphereZ+cz,'FaceColor',[cx cy cz]/maxval,'linestyle','none');
                end
            end
        end
    end
xlabel(repere,'Niveau de rouge','color',[1 0 0])
ylabel(repere,'Niveau de vert','color',[0 1 0])
zlabel(repere,'Niveau de bleu','color',[0 0 1])
end
