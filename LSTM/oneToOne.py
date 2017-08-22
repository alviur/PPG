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
import matplotlib.pyplot as plt
import pickle

def splitSequences(data,lengthD):
    
    b, d = divmod(data.shape[1]/lengthD, 1)
    dataSize = int(b)
    
    try:
        outdata= np.zeros((data.shape[0]*dataSize,lengthD,data.shape[2]))
        
        for i in range(data.shape[0]):
            for j in range(dataSize):
                #print(j+i*dataSize,j+i*lengthD,j+i*lengthD+lengthD)
                outdata[j+i*dataSize,:,:]=data[i,j*lengthD:j*lengthD+lengthD,:]
            
        return outdata          
        
        
        
    except:
        outdata= np.zeros((data.shape[0]*dataSize,lengthD))
        for i in range(data.shape[0]):
            for j in range(dataSize):
                #print(j+i*dataSize,j+i*lengthD,j+i*lengthD+lengthD)
                outdata[j+i*dataSize,:]=data[i,j*lengthD:j*lengthD+lengthD]
            
        return outdata    

# Load data
# Load training data 
dataPath = '/home/lex/Desktop/PPG_DATASET/1_IEEE_Signal_Processing_cup_2015/'

with open(dataPath+'trainningPad', 'rb') as handle:
    trainningPad = pickle.load(handle)
    
with open(dataPath+'trainningLabelsPad', 'rb') as handle:
    trainningLabelsPad = pickle.load(handle)

# Load test data    
with open(dataPath+'testPad', 'rb') as handle:
    testPad = pickle.load(handle)

with open(dataPath+'testLabelsPad', 'rb') as handle:
    testLabelsPad = pickle.load(handle)     

trainningPad = splitSequences(trainningPad,20*50)
trainningLabelsPad = splitSequences(trainningLabelsPad,20*50)
testPad = splitSequences(testPad,20*50)
testLabelsPad = splitSequences(testLabelsPad,20*50)

length = trainningPad.shape[1]
inputS = trainningPad.shape[0] 
output = 1
n_features = 5     

# Define model
model = Sequential()
model.add(LSTM(50, input_shape=(length, n_features)))
model.add(RepeatVector(length))
model.add(LSTM(50, return_sequences=True))
model.add(TimeDistributed(Dense(output, activation='linear')))
model.compile(loss='mae', optimizer='adam')
print(model.summary())



## Fit model
history = model.fit(trainningPad[:,:,0:5],trainningLabelsPad, batch_size=1, epochs=100)
##model.fit(trainningPad[:,:,0:5],trainningLabelsPad, batch_size=1, epochs=1)
#
## Eval model
#out = model.predict(testPad)
#
## Plot
#plt.plot(out[1,:])
#plt.show()
#
plt.plot(a[0,:,5])
plt.show()


