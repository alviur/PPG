# -*- coding: utf-8 -*-
"""============================================================================
Author: Alexander Gomez Villa - SUPSI
email: alexander.gomezvilla@supsi.ch
Load IEEE_Signal_Processing_cup_2015 dataset 
-------------------------------------------------------------------------------
The dataset is saved as a python dictionary wherr row indexes indicates the
subject, Column 1 is the data (variable sig) and column 2 is the label
=============================================================================== 
"""
import os
import numpy as np
import scipy.io
import pickle


# Paths
pathTraining = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/Training_data/'
pathTest = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/TestData/'
pathLabelsTest = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/TestData/TrueBPM/'
savePath = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/' 

# List files 
trainingFiles  = [each for each in os.listdir(pathTraining) if each.endswith('.mat')]
trainingFilesLabels  = [each for each in os.listdir(pathTraining) if each.endswith('e.mat')]
testFiles = [each for each in os.listdir(pathTest) if each.endswith('.mat')]
testFilesLabels = [each for each in os.listdir(pathTest) if each.endswith('.mat')]

trainingP = []
trainingLabels = []
trainingNames = []
test = []
testLabels = []
testNames = []
contTest = 0

# Iterate over training files
for file in trainingFiles:
    
    if(not(file.endswith('e.mat'))):
        # Load matlab file
        dataMat = scipy.io.loadmat(pathTraining+file)
        # Load into Numpy array
        data = dataMat['sig']
        trainingP.append(data.transpose())
        #trainingP[contTrain,0] = data      
        
        labelsMat = scipy.io.loadmat(pathTraining+file[0:-4]+'_BPMtrace.mat')
        labels = labelsMat['BPM0']
        trainingLabels.append(labels.transpose())
        trainingNames.append(file)
        #trainingP[contTrain,1] = labels 

# Save Training files
with open(savePath+'training', 'wb') as handle:
    pickle.dump(trainingP, handle, protocol=pickle.HIGHEST_PROTOCOL)
    
with open(savePath+'trainingLabels', 'wb') as handle:
    pickle.dump(trainingLabels, handle, protocol=pickle.HIGHEST_PROTOCOL)    

with open(savePath+'trainingNames', 'wb') as handle:
    pickle.dump(trainingNames, handle, protocol=pickle.HIGHEST_PROTOCOL)
        
# Iterate over test files
for file in testFiles:
    
    if(not(file.endswith('e.mat'))):
        # Load matlab file
        dataMat = scipy.io.loadmat(pathTest+file)
        # Load into Numpy array
        data = dataMat['sig']
        test.append(data.transpose())
        #test[contTest,0] = data 
        
        labelsMat = scipy.io.loadmat(pathLabelsTest+'True_'+file[-11:])
        labels = labelsMat['BPM0'] 
        testLabels.append(labels.transpose())
        testNames.append(file)

# Save test files        
with open(savePath+'test', 'wb') as handle:
    pickle.dump(test, handle, protocol=pickle.HIGHEST_PROTOCOL)     
    
with open(savePath+'testLabels', 'wb') as handle:
    pickle.dump(testLabels, handle, protocol=pickle.HIGHEST_PROTOCOL)    

with open(savePath+'testNames', 'wb') as handle:
    pickle.dump(testNames, handle, protocol=pickle.HIGHEST_PROTOCOL)    