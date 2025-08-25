function [expCode subCode isiLo isiHi repetitions pauses lrScheme randScheme inputScheme inputDur] = loadExpFile(filePath)
    load(filePath);