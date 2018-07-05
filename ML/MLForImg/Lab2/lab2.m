%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%coursework: face recognition with eigenfaces

% need to replace with your own path
addpath software;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading of the images: You need to replace the directory 
Imagestrain = loadImagesInDirectory ( 'images/training-set/23x28/');
[Imagestest, Identity] = loadTestImagesInDirectory ( 'images/testing-set/23x28/');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computation of the mean, the eigenvalues, amd the eigenfaces stored in the
%facespace:
ImagestrainSizes = size(Imagestrain);
Means = floor(mean(Imagestrain));
CenteredVectors = (Imagestrain - repmat(Means, ImagestrainSizes(1), 1));

CovarianceMatrix = cov(CenteredVectors);

[U, S, V] = svd(CenteredVectors);
Space = V(: , 1 : ImagestrainSizes(1))';
Eigenvalues = diag(S);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display of the mean image:
MeanImage = uint8 (zeros(28, 23));
for k = 0:643
   MeanImage( mod (k,28)+1, floor(k/28)+1 ) = Means (1,k+1);
 
end
figure;
subplot (1, 1, 1);
imshow(MeanImage);
title('Mean Image');

[ covSize, covSize] = size(CovarianceMatrix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display of the 20 first eigenfaces : Write your code here

% since Covariance matrix = centeredvector * centeredvector' -> V are
% ranked eigenvectors .. 
numVectors = 20;
unnormeigens = V(1:numVectors,:);

%figure(5);
for i=1:numVectors
   unnormeigen = unnormeigens(i,:);
   normeigen = renormalise(unnormeigen);
   eigenface2 = double(normeigen) + double(reshape(MeanImage, [ImagestrainSizes(2) 1])');
   eigenface = uint8(renormalise(eigenface2));
   
   eigenface= reshape(eigenface, [28,23]);
   
   subplot (10,2 , i);
   imshow(eigenface);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Projection of the two sets of images omto the face space:
Locationstrain=projectImages (Imagestrain, Means, Space);
Locationstest=projectImages (Imagestest, Means, Space);

Threshold =20;

TrainSizes=size(Locationstrain);
TestSizes = size(Locationstest);
Distances=zeros(TestSizes(1),TrainSizes(1));
%Distances contains for each test image, the distance to every train image.

for i=1:TestSizes(1),
    for j=1: TrainSizes(1),
        Sum=0;
        for k=1: Threshold,
   Sum=Sum+((Locationstrain(j,k)-Locationstest(i,k)).^2);
        end,
     Distances(i,j)=Sum;
    end,
end,

Values=zeros(TestSizes(1),TrainSizes(1));
Indices=zeros(TestSizes(1),TrainSizes(1));
for i=1:70,
[Values(i,:), Indices(i,:)] = sort(Distances(i,:));
end,


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Display of first 6 recognition results, image per image:
figure;
x=6;
y=2;
for i=1:6,
      Image = uint8 (zeros(28, 23));
      for k = 0:643
     Image( mod (k,28)+1, floor(k/28)+1 ) = Imagestest (i,k+1);
      end,
   subplot (x,y,2*i-1);
    imshow (Image);
    title('Image tested');
    
    Imagerec = uint8 (zeros(28, 23));
      for k = 0:643
     Imagerec( mod (k,28)+1, floor(k/28)+1 ) = Imagestrain ((Indices(i,1)),k+1);
      end,
     subplot (x,y,2*i);
imshow (Imagerec);
title(['Image recognised with ', num2str(Threshold), ' eigenfaces:',num2str((Indices(i,1))) ]);
end,



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recognition rate compared to the number of test images: Write your code here to compute the recognition rate using top 20 eigenfaces.

% have to bear in mind that each training image matched corresponds to
% identity floor((index-1)/5) + 1
averageRR=0;

Values=zeros(TestSizes(1),TrainSizes(1));
Indices=zeros(TestSizes(1),TrainSizes(1));
number_of_test_images=zeros(1,40);% Number of test images of one given person.%YY I modified here
for i=1:70
number_of_test_images(1,Identity(1,i))= number_of_test_images(1,Identity(1,i))+1;%YY I modified here

end

recognised_person=zeros(1,40);
recognitionrate=zeros(1,5);
number_per_number=zeros(1,5);


i=1;
while (i<70),
    id=Identity(1,i);   
    distmin=Values(id,1);
        indicemin=Indices(id,1);
%     while (i<70)&&(Identity(1,i)==id), 
%         if (Values(i,1)<distmin),
%             distmin=Values(i,1);
%         indicemin=Indices(i,1);
%         end,
%         i=i+1;
%     
%     end,
    recognised_person(1,id)=indicemin;
    number_per_number(number_of_test_images(1,id))=number_per_number(number_of_test_images(1,id))+1;
    if (id==floor((indicemin-1)/5)+1) %the good personn was recognised
        recognitionrate(number_of_test_images(1,id))=recognitionrate(number_of_test_images(1,id))+1;
        
    end,
    i = i+1; 
   
end,

for  i=1:5,
   recognitionrate(1,i)=recognitionrate(1,i)/number_per_number(1,i);
end,
averageRR=mean(recognitionrate(1,:))


fprintf(sprintf("average RR for 20 eigenfaces %0.1f, recognition rates per individual %0.1f" , averageRR, recognitionrate))
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%effect of threshold (i.e. number of eigenfaces):   
averageRR=zeros(1,20);
for t=1:40,
  Threshold =t;  
Distances=zeros(TestSizes(1),TrainSizes(1));

for i=1:TestSizes(1),
    for j=1: TrainSizes(1),
        Sum=0;
        for k=1: Threshold,
   Sum=Sum+((Locationstrain(j,k)-Locationstest(i,k)).^2);
        end,
     Distances(i,j)=Sum;
    end,
end,

Values=zeros(TestSizes(1),TrainSizes(1));
Indices=zeros(TestSizes(1),TrainSizes(1));
number_of_test_images=zeros(1,40);% Number of test images of one given person.%YY I modified here
for i=1:70,
number_of_test_images(1,Identity(1,i))= number_of_test_images(1,Identity(1,i))+1;%YY I modified here
[Values(i,:), Indices(i,:)] = sort(Distances(i,:));
end,

recognised_person=zeros(1,40);
recognitionrate=zeros(1,5);
number_per_number=zeros(1,5);


i=1;
while (i<70),
    id=Identity(1,i);   
    distmin=Values(id,1);
        indicemin=Indices(id,1);
    while (i<70)&&(Identity(1,i)==id), 
        if (Values(i,1)<distmin),
            distmin=Values(i,1);
        indicemin=Indices(i,1);
        end,
        i=i+1;
    
    end,
    recognised_person(1,id)=indicemin;
    number_per_number(number_of_test_images(1,id))=number_per_number(number_of_test_images(1,id))+1;
    if (id==floor((indicemin-1)/5)+1) %the good personn was recognised
        recognitionrate(number_of_test_images(1,id))=recognitionrate(number_of_test_images(1,id))+1;
        
    end,
   
end,

for  i=1:5,
   recognitionrate(1,i)=recognitionrate(1,i)/number_per_number(1,i);
end,
averageRR(1,t)=mean(recognitionrate(1,:));
end,
figure;
plot(averageRR(1,:));
title('Recognition rate against the number of eigenfaces used');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%effect of K: You need to evaluate the effect of K in KNN and plot the recognition rate against K. Use 20 eigenfaces here.




