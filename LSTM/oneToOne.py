# -*- coding: utf-8 -*-
"""
===============================================================================
Author: Alexander Gomez Villa - SUPSI
Advisor: PhD Igor Stefanini
email: alexander.gomezvilla@supsi.ch
preprocess IEEE_Signal_Processing_cup_2015 dataset 
-------------------------------------------------------------------------------

===============================================================================
"""
# Libraries
import keras
from keras.layers import LSTM,Dense,TimeDistributed,RepeatVector
from keras.models import Sequential
import numpy as np
import pickle

# Load data
# Load training data 
dataPath = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/'

with open(dataPath+'trainningPad', 'rb') as handle:
    trainningPad = pickle.load(handle)
    
with open(dataPath+'trainningLabelsPad', 'rb') as handle:
    trainningLabelsPad = pickle.load(handle)

# Load test data    
with open(dataPath+'testPad', 'rb') as handle:
    testPad = pickle.load(handle)

with open(dataPath+'testLabelsPad', 'rb') as handle:
    testLabelsPad = pickle.load(handle)     

length = trainningPad.shape[1]
inputS = trainningPad.shape[0] 
output = 1
n_features = 5     

# Define model
model = Sequential()
model.add(LSTM(20, input_shape=(length, n_features)))
model.add(RepeatVector(length))
model.add(LSTM(20, return_sequences=True))
model.add(TimeDistributed(Dense(output, activation='linear')))
model.compile(loss='mae', optimizer='adam')
print(model.summary())



# Fit model
history = model.fit(trainningPad[:,:,0:5],trainningLabelsPad, batch_size=1, epochs=1)
