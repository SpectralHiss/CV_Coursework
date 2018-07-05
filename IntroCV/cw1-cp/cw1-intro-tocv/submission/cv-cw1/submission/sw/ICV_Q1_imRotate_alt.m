function img_new = ICV_Q1_imRotate(path, rot_angle, h_skew_angle)

%*****************************************************
% Title: ICV_imRotateF
% Author: Houssem El Fekih
% Input Parameter:
%          path:path of the image,
%          rot_angle: rotation angle in degrees clockwise,
%          h_skew_angle : horizontl skew angle in degrees.

% Description:function to rotate image at arbitrary angle using
%             nearet pixel fill
% Example: ICV_imRotateF('icv_2017.png', 30, 10);
%*****************************************************

%% Create image
img = imread(path);
rad_rot_angle = rem(( (rot_angle / 360)  * 2 * pi) , 2 * pi); % we use rem instead of mod to conserve sign/direction of rotation
rad_skew_angle =(h_skew_angle / 360)  * 2 * pi;

% clockwise is the inverse of the mathematical convention, so all angles
% are flipped
rad_rot_angle = -rad_rot_angle;

% the negative sign ensures that the skewing happens the conventional way
% around.
skew_factor = -tan( rad_skew_angle);

% view the input image
figure(1);
imshow(img);
title('Input');

%% create new image
% height and width of the image

% if image is wide then
%
[h, w, ~] = size(img);

% create the new matrix to store the ;

% we derived this geometrically by constructing a bounded box for rotation
% on a case by case basis. this was coroborated by computing the diff of
% width and height of the image of appropriate corner points.

% to get the right size for skewed images, we first apply horizontal
% stretching to corners to find new width of image then apply the result to
% find the new corners.

skewed_width=w + tan(rad_skew_angle)*h;

if rad_rot_angle >= 0 && rad_rot_angle <= pi / 2
    new_height= (ceil((cos(rad_rot_angle)*h + sin(rad_rot_angle)*skewed_width)));
    new_width = (ceil((cos(rad_rot_angle)*(skewed_width)) + sin(rad_rot_angle)*h) );
end

if rad_rot_angle > pi / 2 && rad_rot_angle < pi
    new_height= ceil(sin(rad_rot_angle)*(skewed_width)-cos(rad_rot_angle)*h);
    new_width = ceil(-cos(rad_rot_angle)*(skewed_width) + sin(rad_rot_angle)*h);
end

if rad_rot_angle < 0 && rad_rot_angle >= -pi/2
    new_width= (ceil((cos(rad_rot_angle)*skewed_width - sin(rad_rot_angle)*h)));
    new_height = (ceil((cos(rad_rot_angle)*h - sin(rad_rot_angle)*skewed_width)));
end

if rad_rot_angle < -pi/2
    new_height= ceil(-sin(rad_rot_angle)*skewed_width-cos(rad_rot_angle)*h);
    new_width = ceil(-cos(rad_rot_angle)*(skewed_width) - sin(rad_rot_angle)*h);
end


% create empty image for the output
img_new = uint8(zeros(new_height,new_width,3));


%% scale the image

%translation to base matrix
new_center_to_origin = [1,0,new_height/2;0,1,new_width/2;0,0,1];
%
back_to_base = [1,0,-(h/2);0,1,-(w/2);0,0,1];
S= [1, skew_factor,0; 0,1,0; 0,0,1];


%transformation matrix for rotation
if rad_rot_angle < 0
    R = [cos(rad_rot_angle),sin(rad_rot_angle),0; -sin(rad_rot_angle),cos(rad_rot_angle),0; 0,0,1];
else
    R = [cos(rad_rot_angle),sin(rad_rot_angle),0; -sin(rad_rot_angle),cos(rad_rot_angle),0; 0,0,1];
end

% Alternative slow way (due to slowness of inv operator in matlab and
%  imprecision of the  \ operatior
M = new_center_to_origin * R * S * back_to_base
invM =  inv(M);

% scale the image, using inverse mapping
for r = 1:new_height
    for c = 1:new_width
        
        pos = invM*[r;c;1]
        
        
        rr = round(pos(1));
        cc = round(pos(2));
        % fill scaled image using input image pixel colors
        if rr>=1 && cc>=1 && rr<= h && cc<= w
            img_new(r,c,:) = img(rr,cc,:);
        end
    end
end
%% view the output image
%figure(2);
imshow(img_new);
title('Output');

end

