#setwd("../../Documents/CS_DST/PR/Assignment/PR/DissRepScenario2/")
library(dplyr)
library(stringr)

files=list.files()
AllFilesTab=data.frame()

for (file in files){
  tab=read.csv(file)
  size=str_extract(file,"PixelSize.*Method")
  size=gsub("(PixelSize|Method)","",size)
  method=str_extract(file,"Method.*(.)csv")
  method=gsub("(Method|(.)csv)","",method)
  summaryTab=summariseRepetitions(tab,method,size)
  AllFilesTab=rbind(AllFilesTab,summaryTab)
}

pd <- position_dodge(0.2) # move them .05 to the left and right

ggplot(AllFilesTab,aes(x=dist,y=m,col=classif))+geom_line(size=1,position=pd) +geom_errorbar(aes(ymin=m-ci, ymax=m+ci), width=.1,position=pd)+theme_bw()+xlab("Dissimilarity Measure")+ylab("Classification Error")


summariseRepetitions=function(tab,method,size){
distmeasures=c("minkowski","polynomial","distance","cosine","ndiff","sigmoid","radial_basis")
errorTableWithMeanSD=data.frame()
classifiers=c("svc","qdc","parzen","loglc","knnc","bpxnc","fisher")
for (classif in classifiers){
  for (dist in distmeasures){
    distexpression=paste("distance",dist,sep="")
    colind=grep(distexpression,colnames(tab))
    subsetTabDist = tab[which(tab$classifier==classif),colind]
    sd=sd(as.numeric(subsetTabDist[1,])) 
    m=mean(as.numeric(subsetTabDist[1,]))
    n = ncol(subsetTabDist)
    ciMultipler = qt(0.975,n-1)
    ci = sd * ciMultipler
    temp=data.frame(classif,dist,m,sd,n,ci,method,size)
    errorTableWithMeanSD=rbind(errorTableWithMeanSD,temp)
  }}
return(errorTableWithMeanSD)}

summariseRepetitions2Distances=function(tab,method,size){
  distmeasures=c("minkowski","polynomial","distance","cosine","radial_basis")
  combinations=combn(distmeasures,2)
  errorTableWithMeanSD=data.frame()
  classifiers=c("svc","qdc","parzen","loglc","knnc","bpxnc","fisher")
  for (classif in classifiers){
    for (dist in c(1:ncol(combinations))){
      dist1=combinations[1,dist]
      dist2=combinations[2,dist]
      distexpression=paste("distance1",dist1,"distance2",dist2,sep="")
      colind=grep(distexpression,colnames(tab))
      if (length(colind)==0){
        distexpression=paste("distance1",dist2,"distance2",dist1,sep="")
        colind=grep(distexpression,colnames(tab))
      }
      subsetTabDist = tab[which(tab$classifier==classif),colind]
      sd=sd(as.numeric(subsetTabDist[1,])) 
      m=mean(as.numeric(subsetTabDist[1,]))
      n = ncol(subsetTabDist)
      ciMultipler = qt(0.975,n-1)
      ci = sd * ciMultipler
      temp=data.frame(classif,dist1,dist2,m,sd,n,ci,method,size)
      errorTableWithMeanSD=rbind(errorTableWithMeanSD,temp)
    }}
  return(errorTableWithMeanSD)}