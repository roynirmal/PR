setwd("../../Documents/CS_DST/PR/Assignment/PR")
library(reshape2)
library(stringr)
library(ggplot2)
library(plotly)
#read errorTable
errorTable=read.csv("testsPR.csv")
errorTable.m=melt(errorTable)


#function to retrieve the value of a certain parameter in the experiment (eg. thresholding = true or false)
extractValueExperiment=function(parameter){
parameterBit= str_extract(errorTable.m$variable, paste("\\.",parameter,".*(\\.|$)",sep=""))
parameterBit =gsub(paste("\\.",parameter,"\\.",sep=""),"",parameterBit)
parameterBit= gsub("\\..*","",parameterBit)
return(parameterBit)
}

#extract all parameters and create a column for each one of them
errorTable.m$nrTrObjectsPerClass = as.numeric(extractValueExperiment("nrTrObjectsPerClass"))
errorTable.m$resizing=extractValueExperiment("resizing")
errorTable.m$resizeSize=extractValueExperiment("resizeSize")
errorTable.m$resizeMethod=extractValueExperiment("resizeMethod")
errorTable.m$thresholding=extractValueExperiment("thresholding")
errorTable.m$variable=NULL


### Plot variation of classification errors with a certain parameter of Interest
summariseErrorTable=function(parameterOfInterest,RemainingParameters){
  #Group tournaments according to their parameterSet
  RemainingParameters=c("resizing","resizeSize","resizeMethod","thresholding")
  parameterSets=unique(errorTable.m[,RemainingParameters])
  errorTable.m$parameterSet=0
  subsetTable=errorTable.m[,RemainingParameters]
  for (i in c(1:nrow(parameterSets))){
    errorTable.m$parameterSet[which((subsetTable[,1]%in%parameterSets[i,1] & subsetTable[,2]%in%parameterSets[i,2] & subsetTable[,3]%in%parameterSets[i,3] & subsetTable[,4]%in%parameterSets[i,4]))]=i
  }
  
errorTableWithMeanSD=data.frame()

#Compute Conf Intervals for each pair class+parameterSet
classifiers=c("svc","qdc","parzen","loglc","knnc","bpxnc")
paramIntvalues=unique(errorTable.m[,parameterOfInterest])
parameterSets = unique(errorTable.m[,"parameterSet"])
for (classif in classifiers){
  for (pSet in parameterSets){
subsetTab=as.data.frame(errorTable.m[which(errorTable.m$X==classif & errorTable.m$parameterSet==pSet),])
for (p in paramIntvalues) {
  subsetErrors=subsetTab$value[which(subsetTab[,parameterOfInterest]==p)]
  sd=sd(subsetErrors)
  m=mean(subsetErrors)
  n = length(subsetErrors)
  ciMultipler = qt(0.975,n-1)
  ci = sd * ciMultipler
  temp=data.frame(classif,p,pSet,m,sd,n,ci)
  errorTableWithMeanSD=rbind(errorTableWithMeanSD,temp)
}
}
}
colnames(errorTableWithMeanSD)= c("Classifier", parameterOfInterest,"ParameterSet","MeanError","SD","N","Cint")
return(errorTableWithMeanSD)
}

sumErrorTable.m = summariseErrorTable("nrTrObjectsPerClass",c("resizing","resizeSize","resizeMethod","thresholding"))
#plot - effect of data size on classification error
pd <- position_dodge(0.2) # move them .05 to the left and right

ggplot(sumErrorTable.m,aes(x=nrTrObjectsPerClass,y=MeanError,col=Classifier,group=interaction(ParameterSet,Classifier)))+geom_line(size=1,position=pd) +geom_errorbar(aes(ymin=MeanError-Cint, ymax=MeanError+Cint), width=.1,position=pd)+theme_bw()

## Parallel Coordinates Plot
colnames(errorTable.m) [c(1,2)] = c("Classifier","ClassError")
#binary features coded as 0 or 1
codeBinary=function(tab,parameter){
  tab[,parameter][which(tab[,parameter]=="true")]=1
  tab[,parameter][which(tab[,parameter]=="false")]=0
  return(tab)
  }
errorTable.m=codeBinary(errorTable.m,"thresholding")
errorTable.m=codeBinary(errorTable.m,"resizing")

#same for features with several categories
codeOrdinal=function(tab,parameter,options,codes){
  tab[,parameter]=as.character(tab[,parameter])
  for (i in c(1:length(options))){
    tab[,parameter][which(tab[,parameter]==options[i])]=codes[i]
  }
  return(tab)
}
errorTable.m=codeOrdinal(errorTable.m,"resizeMethod","bicubic",1)
errorTablePPC=codeOrdinal(errorTable.m,"Classifier",c("svc","qdc","parzen","bpxnc","knnc","loglc"),c(1,2,3,4,5,6))

#options(viewer=NULL) # need this option because plotly doesnt plot well on Rstudio. This makes plotly plot to appear on a browser

#color legend is missing, it has to be added afterwards.
p <- errorTablePPC %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~Classifier,colorscale = list(c(0,'red'),c(0.2,'green'),c(0.4,'darkblue'),c(0.6,"orange"),c(0.8,"purple"),c(1,"darkturquoise")) ),
          dimensions = list(
            list(range = c(0,30),
                 label = 'No.Objects Per Class', values = ~nrTrObjectsPerClass),
            list(range = c(0,1),
                 label = 'Resizing', values = ~resizing),
            list(range = c(7,10),
                 label = 'Resize Size', values = ~resizeSize),
            list(range = c(0,1),
                 label = 'ResizeMethod', values = ~resizeMethod),
            list(range = c(0,1),
                 label = 'Thresholding', values = ~thresholding),
            list(range=c(0,1),  constraintrange = c(0,1), label='Classification Error',values=~ClassError)
          )        
  )