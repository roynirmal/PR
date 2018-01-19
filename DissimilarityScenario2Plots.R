#setwd("../../Documents/CS_DST/PR/Assignment/PR/DissRepScenario2/")
library(dplyr)
library(stringr)

files=list.files()
files=files[-grep("Combinations",files)]
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

pd <- position_dodge(0.3) # move them .05 to the left and right

AllFilesTabBicubic=AllFilesTab[which(AllFilesTab$method=="Bicubic"),]
ggplot(AllFilesTabBicubic,aes(x=dist,y=m,col=classif))+geom_line(size=1,position=pd) +geom_boxplot()+theme_bw()+xlab("Dissimilarity Measure")+ylab("Classification Error")


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
  classifiers=c("svc","rbsvc","pksvc","qdc","parzen","loglc","knnc","bpxnc","fisher")
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

errorTable.PPC=codeOrdinal(AllFilesTab,"Classifier",c("svc","qdc","parzen","bpxnc","knnc","loglc","fisher","treec"),c(1,2,3,4,5,6,7,8))
errorTable.PPC=codeOrdinal(errorTable.PPC,"Distance",c("minkowski","distance","polynomial","cosine"),c(1,2,3,4))

p <- errorTable.PPC%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassifError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = 0,
                      cmax = 0.1),
          dimensions = list(
            list(range = c(0,600),
                 label = 'No.Training', values = ~Training),
            list(range = c(0,20),
                 label = 'Resize Size', values = ~ResizeSize),
            list(range = c(0,500),
                 label = 'Prototypes', values = ~Prototypes),
            list(range = c(1,8),
                 label = 'Classifiers', values = ~Classifier),
            list(range=c(0,0.1),  constraintrange = c(0,0.05), label='Classification Error',values=~ClassifError)
          )
  )
