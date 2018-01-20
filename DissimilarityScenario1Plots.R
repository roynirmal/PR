#setwd("../../Documents/CS_DST/PR/Assignment/PR/DissRepScenario1/")
library(stringr)
library(plotly)
files=list.files()
AllFilesTab=data.frame()

meltDissScen1=function(tab,training,size){
  distmeasures=c("minkowski","polynomial","distance","cosine")
  errorTable=data.frame()
  classifiers=c("svc","qdc","parzen","loglc","knnc","bpxnc","fisher")
  for (classif in classifiers){
    for (dist in distmeasures){
      distexpression=paste("distance",dist,sep="")
      colind=grep(distexpression,colnames(tab))
      subsetTabDist = tab[which(tab$classifier==classif),colind]
      for (i in c(1:ncol(subsetTabDist))){
        colname=colnames(subsetTabDist)[i]
        prot=str_extract(colname,"prototypes(.).*(.training)")
        prot = gsub("(prototypes|(.training))","",prot)
        error=subsetTabDist[1,i]
        temp=data.frame(Classifier=classif,Distance=dist,Prototypes=as.numeric(prot),Training=training,ResizeSize=size,ClassifError=error)
        errorTable=rbind(errorTable,temp)
      }
    }
    }
  return(errorTable)}

#same for features with several categories
codeOrdinal=function(tab,parameter,options,codes){
  tab[,parameter]=as.character(tab[,parameter])
  for (i in c(1:length(options))){
    tab[,parameter][which(tab[,parameter]==options[i])]=codes[i]
  }
  tab[,parameter]=as.numeric(tab[,parameter])
  return(tab)
}

for (file in files){
  tab=read.csv(file)
  size=str_extract(file,"Size.*(.)csv")
  size=gsub("(Size|(.)csv)","",size)
  training=str_extract(file,"Prototypes.*PixelSize")
  training=gsub("(Prototypes|PixelSize)","",training)
  summaryTab=meltDissScen1(tab,training,size)
  AllFilesTab=rbind(AllFilesTab,summaryTab)
}

AllFilesTabNoSVCBP=AllFilesTab[which(AllFilesTab$Classifier!="svc" &AllFilesTab$Classifier!="bpxnc"&AllFilesTab$Prototypes%in%c(20,30,40,60,70,80,90)==FALSE),]
AllFilesTabNoSVCBP$Training=as.numeric(as.character(AllFilesTabNoSVCBP$Training))
AllFilesTabNoSVCBP$ResizeSize=as.numeric(as.character(AllFilesTabNoSVCBP$ResizeSize))

errorTable.PPC=codeOrdinal(AllFilesTabNoSVCBP,"Classifier",c("qdc","parzen","knnc","loglc","fisher"),c(1,2,3,4,5))
errorTable.PPC=codeOrdinal(errorTable.PPC,"Distance",c("minkowski","distance","polynomial","cosine"),c(1,2,3,4))

p <- errorTable.PPC%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassifError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC$ClassifError),
                      cmax = 0.05),
          dimensions = list(
            list(range = c(0,600),
                 label = 'No.Training', values = ~jitter(as.numeric(Training))),
            list(range = c(0,20),
                 label = 'Resize Size', values = ~jitter(as.numeric(ResizeSize))),
            list(range = c(0,500),
                 label = 'Prototypes', values = ~jitter(Prototypes)),
            list(range = c(1,4),
                 label = 'Dissimilarity Measure', values = ~jitter(Distance),tickvals = c(1,2,3,4),ticktext = c("minkowski","euclidean","polynomial","cosine")),
            list(range = c(0,6),
                 label = 'Classifiers', values = ~jitter(Classifier),tickvals = c(1,2,3,4,5),ticktext = c("qdc","parzen","knnc","loglc","fisher")),
            list(range=c(0,1),  constraintrange = c(0,0.05), label='Classification Error',values=~ClassifError)
          )
  )%>%   layout(font=list(size=19,color = "#000000"))


#Influence of Prototypes and Representatives
#opt conditions size =8, dist = distance
optTable=AllFilesTab[which(AllFilesTab$ResizeSize==10&AllFilesTab$Distance=="distance"),]
optClassifiers=c("loglc","fisher","knnc")
optTable=optTable[which(optTable$Classifier%in%optClassifiers==TRUE),]
ggplot(optTable,aes(x=Prototypes,y=ClassifError,group=interaction(Training,Classifier),col=interaction(Training,Classifier)))+geom_line(size=1) +ylim(c(0,0.05))+theme_bw()

ggplot(AllFilesTabNoSVCBP,aes(x=ResizeSize,y=ClassifError,group=Classifier))+geom_boxplot()+theme_bw()

#Influence of PixelSize
optTable=AllFilesTabNoSVCBP[which(AllFilesTabNoSVCBP$Distance=="distance" &AllFilesTabNoSVCBP$Classifier=="fisher"),]
ggplot(optTable,aes(x=ResizeSize,y=ClassifError,group=ResizeSize))+geom_boxplot()+theme_bw()


#Influence of PixelSize, compare with Scenario 2, distance = euclidean, classifier fisher, bicubic
Scenario2=read.csv("../SummaryTablesAllExperiments/DissRepSce2.csv")
Scenario2=Scenario2[which(Scenario2$method=="Bicubic"),]
Scenario2=data.frame(Classifier=Scenario2$classif,Distance=Scenario2$dist,Training=rep(10,nrow(Scenario2)),ResizeSize=Scenario2$size,ClassifError=Scenario2$m)
Scenario1 = AllFilesTab[which(AllFilesTab$Distance=="distance"&(AllFilesTab$Prototypes==100)&AllFilesTab$Training==200),]
Scenario1$Prototypes=NULL
Scenario1$Training=200

AllTogether=rbind(Scenario1,Scenario2)
AllTogetherFisherEuc=AllTogether[which(AllTogether$Classifier=="fisher"&AllTogether$Distance=="distance"),]
AllTogetherFisherEuc$ResizeSize=as.character(AllTogetherFisherEuc$ResizeSize)
AllTogetherFisherEuc$ResizeSize[is.na(AllTogetherFisherEuc$ResizeSize)]=13
AllTogetherFisherEuc$ResizeSize=as.numeric(AllTogetherFisherEuc$ResizeSize)
AllTogetherFisherEuc$Training=as.factor(AllTogetherFisherEuc$Training)
library(gridExtra)

ggplot(AllTogetherFisherEuc[which(AllTogetherFisherEuc$Training==200),],aes(x=ResizeSize,y=ClassifError,col=Training,group=Training))+geom_line(size=1)+theme_bw()+theme(legend.position=c(.7,.8))+xlab("Resizing size")+ylab("Classification Error")+labs(color="Number of Training\n objects")

ggplot(AllTogetherFisherEuc[which(AllTogetherFisherEuc$Training==10),],aes(x=ResizeSize,y=ClassifError,col=Training,group=Training))+geom_line(size=1)+theme_bw()+theme(legend.position=c(.7,.8))+xlab("Resizing size")+ylab("Classification Error")+labs(color="Number of Training\n objects")


