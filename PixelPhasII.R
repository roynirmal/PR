#Pixel Plots Phase II
#setwd("../../Documents/CS_DST/PR/Assignment/PR/PixelPhase2")
source("../Rplots.R")

#retrieve all files
files=list.files()

#produce errorTables and merge all into one
erTab=data.frame()
for (file in files){
  tempErTab=processFile(file)
  erTab=rbind(erTab,tempErTab)
}

write.csv(erTab,"../experimentsPixelPhase2/SummaryTablePixelPhaseII.csv")
erTab=erTab[which(erTab$nrFeatures==0&erTab$X!="treec"&erTab$X!="fisherc"),]
erTabNoNAN=erTab[which(!is.nan(erTab$value)),]


options(viewer=NULL)
#remove nans
errorTable.PPC=codeAllVariables(erTabNoNAN)

errorTable.PPC.Ph2Sc1=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==200),]
p <- errorTable.PPC.Ph2Sc1%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph2Sc1$ClassError),
                      cmax = 0.06),
          dimensions = list(
            list(range = c(0,18),
                 label = 'Resize Size', values = ~resizeSize,tickvals = seq(0,18,2),ticktext = as.character(seq(0,18,2))),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.8,0.95),ticktext = as.character(c("No PCA","0.80","0.95"))),
            list(range = c(1,6),
                 label = 'Classifier', values = ~Classifier,tickvals = c(1,2,3,4,5,6),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc")),
            list(range=c(0,1),  constraintrange = c(0,0.06),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))

errorTable.PPC.Ph2Sc2=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==10),]
p <- errorTable.PPC.Ph2Sc2%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph2Sc2$ClassError),
                      cmax = 0.25),
          dimensions = list(
            list(range = c(0,18),
                 label = 'Resize Size', values = ~resizeSize,tickvals = seq(0,18,2),ticktext = as.character(seq(0,18,2))),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.8,0.95),ticktext = as.character(c("No PCA","0.80","0.95"))),
            list(range = c(1,6),
                 label = 'Classifier', values = ~Classifier,tickvals = c(1,2,3,4,5,6),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc")),
            list(range=c(0,1),  constraintrange = c(0,0.25),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))

