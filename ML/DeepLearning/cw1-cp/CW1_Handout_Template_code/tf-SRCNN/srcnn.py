import time
import os
import matplotlib.pyplot as plt

import numpy as np
import tensorflow as tf
import scipy
import skimage.measure as measure
import pdb


def imread(path, is_grayscale=True):
  """
  Read image using its path.
  Default value is gray-scale, and image is read by YCbCr format as the paper said.
  """
  if is_grayscale:
    return scipy.misc.imread(path, flatten=True, mode='YCbCr').astype(np.float)
  else:
    return scipy.misc.imread(path, mode='YCbCr').astype(np.float)

def modcrop(image, scale=3):
  """
  To scale down and up the original image, first thing to do is to have no remainder while scaling operation.

  We need to find modulo of height (and width) and scale factor.
  Then, subtract the modulo from height (and width) of original image size.
  There would be no remainder even after scaling operation.
  """
  if len(image.shape) == 3:
    h, w, _ = image.shape
    h = h - np.mod(h, scale)
    w = w - np.mod(w, scale)
    image = image[0:h, 0:w, :]
  else:
    h, w = image.shape
    h = h - np.mod(h, scale)
    w = w - np.mod(w, scale)
    image = image[0:h, 0:w]
  return image

def preprocess(path, scale=3):
  """
  Preprocess single image file
    (1) Read original image as YCbCr format (and grayscale as default)
    (2) Normalize
    (3) Apply image file with bicubic interpolation
  Args:
    path: file path of desired file
    input_: image applied bicubic interpolation (low-resolution)
    label_: image with original resolution (high-resolution)
  """
  image = imread(path, is_grayscale=True)
  label_ = modcrop(image, scale)

  # Must be normalized
  image = image / 255.
  label_ = label_ / 255.

  input_ = scipy.ndimage.interpolation.zoom(label_, (1./scale), prefilter=False)
  input_ = scipy.ndimage.interpolation.zoom(input_, (scale/1.), prefilter=False)
  return input_, label_

"""Set the image hyper parameters
"""
c_dim = 1
input_size = 255

"""Define the model weights and biases 
"""

# define the placeholders for inputs and outputs
inputs = tf.placeholder(tf.float32, [None, input_size , input_size , c_dim], name='inputs')

## ------ Add your code here: set the weight of three conv layers
# replace '0' with your hyper parameter numbers 
# conv1 layer with biases: 64 filters with size 9 x 9
# conv2 layer with biases and relu: 32 filters with size 1 x 1
# conv3 layer with biases and NO relu: 1 filter with size 5 x 5
weights = {
    'w1': tf.Variable(tf.random_normal([ 9, 9,1, 64], stddev=1e-3), name='w1'),
    'w2': tf.Variable(tf.random_normal([ 1, 1, 64, 32], stddev=1e-3), name='w2'),
    'w3': tf.Variable(tf.random_normal([5, 5, 32, 1], stddev=1e-3), name='w3')
    }

biases = {
      'b1': tf.Variable(tf.zeros([64]), name='b1'),
      'b2': tf.Variable(tf.zeros([32]), name='b2'),
      'b3': tf.Variable(tf.zeros([1]), name='b3')
    }

"""Define the model layers with three convolutional layers
"""
## ------ Add your code here: to compute feature maps of input low-resolution images
# replace 'None' with your layers: use the tf.nn.conv2d() and tf.nn.relu()
# conv1 layer with biases and relu : 64 filters with size 9 x 9

fr1 = tf.nn.conv2d(inputs, weights['w1'], [1,1,1,1], "VALID", False)
conv1 = tf.nn.relu(tf.nn.bias_add(fr1, biases['b1']))

##------ Add your code here: to compute non-linear mapping
# conv2 layer with biases and relu: 32 filters with size 1 x 1
fr2 = tf.nn.conv2d(conv1, weights['w2'], [1,1,1,1], "VALID", False)
conv2 = tf.nn.relu(tf.nn.bias_add(fr2, biases['b2']))

##------ Add your code here: compute the reconstruction of high-resolution image
# conv3 layer with biases and NO relu: 1 filter with size 5 x 5
conv3 = tf.nn.bias_add(tf.nn.conv2d(conv2, weights['w3'], [1,1,1,1], "VALID", False), biases['b3'])


"""Load the pre-trained model file
"""
model_path='./model/model.npy'
model = np.load(model_path,encoding="latin1").item()
##------ Add your code here: show the weights of model and try to visualisa
# variabiles (w1, w2, w3)

def renorm(array):
  mini = min(array.flatten())
  maxi = max(array.flatten())
  return ((array - (mini)) * 255/(maxi-mini)).astype('uint8')

w1 = model['w1']
w2 = model['w2']
w3 = model['w3']

allweights = plt.figure()

figtitle = 'All filters'
t = allweights.text(0.5, 0.95, figtitle,
                    horizontalalignment='center',fontsize=16)

allweights.text(0.05,0.9, "W1 convolution layer 1 filters:",fontsize=12)

for i in range(32):
  im = allweights.figimage(renorm(w1[:,:,0,i]),xo=15+(15 * i), yo=400)

print("W2 coeficients (1x1 conv.) for 64d features to 32d")

for ii in range(32):
  print("#{0} dimension".format(ii))
  coefs= w2[0,0,:,ii]
  print(renorm(coefs))

allweights.text(0.05, 0.5, "W3 coeficients (5x5 convr) ")

for i in range(32):
  im = allweights.figimage(renorm(w3[:,:,i,0]),xo=(15 * i + 10), yo=150)




"""Initialize the model variabiles (w1, w2, w3, b1, b2, b3) with the pre-trained model file
"""
# launch a session
sess = tf.Session()

for key in weights.keys():
  sess.run(weights[key].assign(model[key]))

for key in biases.keys():
  sess.run(biases[key].assign(model[key]))


"""Read the test image
"""
blurred_image, groundtruth_image = preprocess('./image/butterfly_GT.bmp')

"""Run the model and get the SR image
"""
# transform the input to 4-D tensor
input_ = np.expand_dims(np.expand_dims(blurred_image, axis =0), axis=-1)
# run the session
# here you can also run to get feature map like 'conv1' and 'conv2'
output_ = sess.run(conv3, feed_dict={inputs: input_})

print(output_)
##------ Add your code here: save the blurred and SR images and compute the psnr
# hints: use the 'scipy.misc.imsave()'  and ' skimage.meause.compare_psnr()'

def crop(image):
  return image[6:249,6:249]

output_image = np.reshape(output_,(243,243)).astype('float64')
scipy.misc.imsave('./output/superfly-ground.bmp', groundtruth_image)
scipy.misc.imsave('./output/superfly-pred.bmp',output_image)
scipy.misc.imsave('./output/superfly-blur.bmp', blurred_image.astype('float64'))

print("PSNR between ground truth and bilinear interpolant: #{0}".format(measure.compare_psnr( groundtruth_image , blurred_image)))

print("PSNR between ground truth and prediction: #{0}".format(measure.compare_psnr(crop(groundtruth_image), output_image)))

plt.show()
