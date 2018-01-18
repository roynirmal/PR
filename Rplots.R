#setwd("../../Documents/CS_DST/PR/Assignment/PR")
library(reshape2)
library(stringr)
library(ggplot2)
library(plotly)

#Retrieve all files
#filename="data10resizeSize10resizeMethodnearestfeatureTrueThreshFale.csv"

####Process an individual file
#function to retrieve the value of a certain parameter in the experiment (eg. thresholding = true or false)
extractValueExperiment=function(errorTable.m,parameter){
  parameterBit= str_extract(errorTable.m$variable, paste("(\\.|^)",parameter,".*(\\.|$)",sep=""))
  parameterBit =gsub(paste("(\\.|^)",parameter,"\\.",sep=""),"",parameterBit)
  parameterBit= gsub("\\..*","",parameterBit)
  return(parameterBit)
}

processFile = function(filename){

#read errorTable
errorTable=read.csv(filename)
errorTable.m=melt(errorTable)

#extract all parameters and create a column for each one of them
errorTable.m[,"nrTrObjectsPerClass"] = as.numeric(extractValueExperiment(errorTable.m,"nrTrObjectsPerClass"))
errorTable.m["resizeSize"]=extractValueExperiment(errorTable.m,"resizeSize")
errorTable.m["resizeMethod"]=extractValueExperiment(errorTable.m,"resizeMethod")
errorTable.m["thresholding"]=extractValueExperiment(errorTable.m,"thresholding")
errorTable.m["nrFeatures"]=extractValueExperiment(errorTable.m,"nrFeatures")
errorTable.m["featSelect"]=extractValueExperiment(errorTable.m,"featSelect")
pca = str_extract(errorTable.m$variable, paste("(\\.|(^|(.)pca))","pca",".*",sep=""))
errorTable.m["pca"]=as.numeric(gsub(".pca.|.pcadim.*","",pca))

#features
represent=str_extract(filename, paste("feature.*Thresh",sep=""))
represent=gsub("(feature|Thresh)","",represent)

if (represent=="True"){
  errorTable.m["Representation"]="Features"
}else if (represent =="False"){
  errorTable.m["Representation"]="Pixels"
}else if (represent=="Diss"){
  errorTable.m["Representation"]="Dissimilarity"
}
errorTable.m$variable=NULL
return(errorTable.m)
}


### Plot variation of classification errors with a certain parameter of Interest
summariseErrorTable=function(errorTable.m,parameterOfInterest){
  #Group tournaments according to their parameterSet
#  RemainingParameters=setdiff(colnames(erTab),c("X","value",parameterOfInterest))
#  parameterSets=unique(errorTable.m[,RemainingParameters])
#  errorTable.m$parameterSet=0
#  subsetTable=errorTable.m[,c(parameterOfInterest)]
#  parameterSets=unique(subsetTable)
#  for (i in c(1:length(parameterSets))){
#    errorTable.m$parameterSet[which((parameterSets[i]==subsetTable))]=i
#  }
  
errorTableWithMeanSD=data.frame()

#Compute Conf Intervals for each pair class+parameterSet
classifiers=c("svc","qdc","parzen","loglc","knnc","bpxnc","treec")
paramIntvalues=unique(errorTable.m[,parameterOfInterest])
#parameterSets = unique(errorTable.m[,"parameterSet"])
for (classif in classifiers){
  for (pSet in paramIntvalues){
  subsetTab=as.data.frame(errorTable.m[which(errorTable.m$X==classif & errorTable.m[,parameterOfInterest]==pSet),])
  subsetErrors=subsetTab$value
  sd=sd(subsetErrors)
  m=mean(subsetErrors)
  n = length(subsetErrors)
  ciMultipler = qt(0.975,n-1)
  ci = sd * ciMultipler
  temp=data.frame(classif,pSet,m,sd,n,ci)
  errorTableWithMeanSD=rbind(errorTableWithMeanSD,temp)
}
}
colnames(errorTableWithMeanSD)= c("Classifier", parameterOfInterest,"MeanError","SD","N","Cint")
return(errorTableWithMeanSD)
}

#sumErrorTable.m = summariseErrorTable("nrTrObjectsPerClass",c("resizeSize","resizeMethod","thresholding"))
#plot - effect of data size on classification error
#pd <- position_dodge(0.2) # move them .05 to the left and right

#ggplot(sumErrorTable.m,aes(x=nrTrObjectsPerClass,y=MeanError,col=Classifier,group=interaction(ParameterSet,Classifier)))+geom_line(size=1,position=pd) +geom_errorbar(aes(ymin=MeanError-Cint, ymax=MeanError+Cint), width=.1,position=pd)+theme_bw()


## Parallel Coordinates Plot ##

#binary features coded as 0 or 1
codeBinary=function(tab,parameter){
  tab[,parameter][which(tab[,parameter]=="true")]=1
  tab[,parameter][which(tab[,parameter]=="false")]=0
  tab[,parameter]=as.numeric(tab[,parameter])
  return(tab)
  }


#same for features with several categories
codeOrdinal=function(tab,parameter,options,codes){
  tab[,parameter]=as.character(tab[,parameter])
  for (i in c(1:length(options))){
    tab[,parameter][which(tab[,parameter]==options[i])]=codes[i]
  }
  tab[,parameter]=as.numeric(tab[,parameter])
  return(tab)
}
#Code all variables
codeAllVariables=function(errorTable.m){
errorTable.PPC=errorTable.m
colnames(errorTable.PPC) [c(1,2)] = c("Classifier","ClassError")
errorTable.PPC=codeBinary(errorTable.PPC,"thresholding")
errorTable.PPC=codeOrdinal(errorTable.PPC,"resizeMethod",c("bicubic","bilinear","nearest","box"),c(1,2,3,4))
errorTable.PPC=codeOrdinal(errorTable.PPC,"Classifier",c("svc","qdc","parzen","bpxnc","knnc","loglc","treec"),c(1,2,3,4,5,6,7))
errorTable.PPC=codeOrdinal(errorTable.PPC,"Representation",c("Pixels","Features","Dissimilarity"),c(1,2,3))

return(errorTable.PPC)
}

#options(viewer=NULL) # need this option because plotly doesnt plot well on Rstudio. This makes plotly plot to appear on a browser
