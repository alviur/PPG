# -*- coding: utf-8 -*-
"""
===============================================================================
Author: Alexander Gomez Villa - SUPSI
email: alexander.gomezvilla@supsi.ch
preprocess IEEE_Signal_Processing_cup_2015 dataset 
===============================================================================
"""

import numpy as np
import pickle
from keras.preprocessing.sequence import pad_sequences
from sklearn.preprocessing import normalize
from sklearn.preprocessing import MinMaxScaler

# Main Paths
dataPath = '/home/lex/Desktop/PPG_DATASET/1_IEEE_Signal_Processing_cup_2015/' 

# Load training data 
with open(dataPath+'training', 'rb') as handle:
    unserialized_data = pickle.load(handle)
    
with open(dataPath+'trainingLabels', 'rb') as handle:
    unserialized_data = pickle.load(handle)

# Load test data    
with open(dataPath+'test', 'rb') as handle:
    unserialized_data = pickle.load(handle)

with open(dataPath+'testLabels', 'rb') as handle:
    unserialized_data = pickle.load(handle)    
    

fs = 125 # Sample frecuency
trainLabels2 = []
maxLength = 0
for i in range(len(trainingP)):
    
    tempLabel=trainingLabels[i]    
    trainingMatLab = np.zeros((trainingP[i].shape[0],1))
    
    if(trainingP[i].shape[0]>maxLength):
        maxLength = trainingP[i].shape[0]
        
    
    for j in range(0,tempLabel.shape[1]):
        
        trainingMatLab[j*fs*3:j*fs*3+fs*3,0] = tempLabel[0,j]
        
    trainLabels2.append(trainingMatLab)


## Sequence padding
trainningPad = np.zeros((len(trainingP),maxLength,6))
trainningLabelsPad = np.zeros((len(trainingP),maxLength,1))

for i in range(trainningPad.shape[0]):
    
    tempArray = trainingP[i]
    tempArrayLab = trainLabels2[i]
    
    try:
        trainningPad[i,:,:] = tempArray
        trainningLabelsPad[i,:,:] = tempArrayLab
    except:
        trainningPad[i,0:tempArray.shape[0],:] = tempArray
        trainningLabelsPad[i,0:tempArray.shape[0],:] = tempArrayLab
            
    
## Normalize data
for i in range(trainningPad.shape[0]):   
    
    for j in range(trainningPad.shape[2]):
        trainningPad[i,:,j]=(trainningPad[i,:,j]+
        np.sign(min(trainningPad[i,:,j]))*min(trainningPad[i,:,j]))
        trainningPad[i,:,j]=trainningPad[i,:,j]/(max(trainningPad[i,:,j]))

###############################################################################
testLabels2 = []
for i in range(len(test)):
    
    tempLabel=testLabels[i]    
    trainingMatLab = np.zeros((test[i].shape[0],1))
    
    if(test[i].shape[0]>maxLength):
        maxLength = test[i].shape[0]
        
    
    for j in range(0,tempLabel.shape[1]):
        
        trainingMatLab[j*fs*3:j*fs*3+fs*3,0] = tempLabel[0,j]
        
    testLabels2.append(trainingMatLab)
    
    
 
## Sequence padding
testPad = np.zeros((len(test),maxLength,5))
testLabelsPad = np.zeros((len(test),maxLength))

for i in range(testPad.shape[0]):
    
    tempArray = test[i]
    tempArrayLab = testLabels2[i]
    
    try:
        testPad[i,:,:] = tempArray
        testLabelsPad[i] = tempArrayLab[:,0]
    except:
        testPad[i,0:tempArray.shape[0],:] = tempArray
        testLabelsPad[i,0:tempArrayLab.shape[0]] = tempArrayLab[:,0]
            
    
## Normalize data
for i in range(testPad.shape[0]):   
    
    for j in range(testPad.shape[2]):
        testPad[i,:,j]=(testPad[i,:,j]+
        np.sign(min(testPad[i,:,j]))*min(testPad[i,:,j]))
        testPad[i,:,j]=testPad[i,:,j]/(max(testPad[i,:,j]))   
    
    
####### Save Padded series
savePath = dataPath
# Save test files        
with open(savePath+'testPad', 'wb') as handle:
    pickle.dump(testPad, handle, protocol=pickle.HIGHEST_PROTOCOL)     
    
with open(savePath+'testLabelsPad', 'wb') as handle:
    pickle.dump(testLabelsPad, handle, protocol=pickle.HIGHEST_PROTOCOL)    

with open(savePath+'trainningPad', 'wb') as handle:
    pickle.dump(trainningPad, handle, protocol=pickle.HIGHEST_PROTOCOL)     
    
with open(savePath+'trainningLabelsPad', 'wb') as handle:
    pickle.dump(trainningLabelsPad, handle, protocol=pickle.HIGHEST_PROTOCOL) 
     
    