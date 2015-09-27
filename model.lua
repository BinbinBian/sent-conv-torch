require 'torch'
require 'nn'

-- Hyperparameters
local num_channels = 1
local num_feat_maps = 100 -- Number of feature maps after 1st convolution.
local filt_size = 3
local num_classes = 2
local dropout_p = 0.5

local vocab_size = 3 
-- Input matrix is sent_size by vec_size
-- Note: need to pad sentence lengths before inputting into net
local sent_size = 7 -- max sentence size
local vec_size = 300 -- word2vec vector size

local model = nn.Sequential()
model:add(nn.LookupTable(vocab_size, vec_size)) -- LookupTable for word2vec
model:add(nn.View(1, -1, vec_size)) -- reshape into channels
model:add(nn.SpatialConvolution(num_channels, num_feat_maps, vec_size, filt_size))
model:add(nn.ReLU())
model:add(nn.Max(2)) -- max over second direction

model:add(nn.View(num_feat_maps))
model:add(nn.Dropout(dropout_p))
model:add(nn.Linear(num_feat_maps, num_classes))
model:add(nn.ReLU())
model:add(nn.LogSoftMax())

-- constrain L2 norm with ||w||_2 = s in gradient descent

return model