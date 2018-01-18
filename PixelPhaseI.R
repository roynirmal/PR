#PixelPlots
#setwd("../../Documents/CS_DST/PR/Assignment/PR/experimentspixelNirmal")
source("../Rplots.R")

#retrieve all files
files=list.files()

#produce errorTables and merge all into one
erTab=data.frame()
for (file in files){
  tempErTab=processFile(file)
  erTab=rbind(erTab,tempErTab)
}
write.csv(erTab,"SummaryTablePixelPhaseI.csv")

options(viewer=NULL)
#remove nans
erTabNoNAN=erTab[which(!is.nan(erTab$value)),]
errorTable.PPC=codeAllVariables(erTabNoNAN)
errorTable.PPC=codeOrdinal(errorTable.PPC,"nrFeatures",c(0,5,20,50),c(4,2,3,1))

errorTable.PPC.Ph1Sc1=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==200),]
p <- errorTable.PPC.Ph1Sc1%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph1Sc1$ClassError),
                      cmax = 0.1),
          dimensions = list(
            list(range = c(0,5),
                 label = 'Resize Method', values = ~jitter(resizeMethod),tickvals = c(1,2,3,4),ticktext = c("bicubic","bilinear","nearest","box")),
            list(range = c(0,18),
                 label = 'Resize Size', values = ~resizeSize,tickvals = seq(0,18,2),ticktext = as.character(seq(0,18,2))),
            list(range = c(0,1),
                 label = 'Thresholding', values = ~jitter(thresholding),tickvals = c(0,1),ticktext =c("False","True")),
            list(range = c(1,4),
                 label = 'No.Features', values = ~nrFeatures,tickvals = c(1,2,3,4),ticktext = c("5","20","50","All")),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.8,0.95),ticktext = as.character(c("No PCA","0.80","0.95"))),
            list(range = c(1,8),
                 label = 'Classifier', values = ~Classifier,tickvals = c(1,2,3,4,5,6,7),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc","treec")),
            list(range=c(0,1),  constraintrange = c(0,0.1),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))

errorTable.PPC.Ph1Sc2=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==10),]
p <- errorTable.PPC.Ph1Sc2%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph1Sc2$ClassError),
                      cmax = 0.3),
          dimensions = list(
            list(range = c(0,5),
                 label = 'Resize Method', values = ~jitter(resizeMethod),tickvals = c(1,2,3,4),ticktext = c("bicubic","bilinear","nearest","box")),
            list(range = c(0,18),
                 label = 'Resize Size', values = ~resizeSize,tickvals = seq(0,18,2),ticktext = as.character(seq(0,18,2))),
            list(range = c(0,1),
                 label = 'Thresholding', values = ~jitter(thresholding),tickvals = c(0,1),ticktext =c("False","True")),
            list(range = c(1,4),
                 label = 'No.Features', values = ~nrFeatures,tickvals = c(1,2,3,4),ticktext = c("5","20","50","All")),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.8,0.95),ticktext = as.character(c("No PCA","0.80","0.95"))),
            list(range = c(1,8),
                 label = 'Classifier', values = ~Classifier,tickvals = c(1,2,3,4,5,6,7),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc","treec")),
            list(range=c(0,1),  constraintrange = c(0,0.3),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))

