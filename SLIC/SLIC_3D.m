load mri;
D = squeeze(D);
A = ind2gray(D,map);

slic = [];
slic0 = [];
meanArr = [];
AllmeanArr = [];


for i = 10:5:50
    [L,N] = superpixels3(A,i,Method = 'slic', Compactness=0.01);
    imSize = size(A);
    imPlusBoundaries = zeros(imSize(1),imSize(2),3,imSize(3),'uint8');
    for plane = 1:imSize(3)
      BW = boundarymask(L(:, :, plane));
      imPlusBoundaries(:, :, :, plane) = imoverlay(A(:, :, plane), BW, 'green');
    end
    slic=[slic, imPlusBoundaries];
end

for i = 10:5:50
    [L,N] = superpixels3(A,i,Method = 'slic0',Compactness=0.01);
    imSize = size(A);
    imPlusBoundaries = zeros(imSize(1),imSize(2),3,imSize(3),'uint8');
    for plane = 1:imSize(3)
      BW = boundarymask(L(:, :, plane));
      imPlusBoundaries(:, :, :, plane) = imoverlay(A(:, :, plane), BW, 'green');
    end
    slic0=[slic0, imPlusBoundaries];
end

for i = 10:5:50
    meanArr =[];
    for c = [0.0001, 0.001, 0.01, 0.1, 1]
        [L,N] = superpixels3(A,i, method = 'slic',  Compactness = c);
        pixelIdxList = label2idx(L);
        meanA = zeros(size(A),'like',D);
        for superpixel = 1:N
             memberPixelIdx = pixelIdxList{superpixel};
             meanA(memberPixelIdx) = mean(A(memberPixelIdx));
        end
        meanArr = [meanArr;meanA];
    end
    AllmeanArr = [AllmeanArr,meanArr];
end
implay(A,5)%original mri
implay([slic0;slic],5)% slic0 & slic
implay(AllmeanArr,5)%All results of slic0
