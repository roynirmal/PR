#Produce Plots
source("Rplots.R")

#retrieve all files
files=list.files()

#produce errorTables and merge all into one
erTab=data.frame()
for (file in files){
  tempErTab=processFile(file)
  erTab=rbind(erTab,tempErTab)
}

#Analyse trend for each classifier regarding one variable.
sumErrorTable.m = summariseErrorTable(erTab,"nrFeatures")
pd <- position_dodge(0.2) # move them .05 to the left and right
ggplot(sumErrorTable.m,aes(x=nrFeatures,y=MeanError,col=Classifier,group=Classifier))+geom_line(size=1,position=pd) +geom_errorbar(aes(ymin=MeanError-Cint, ymax=MeanError+Cint), width=.1,position=pd)+theme_bw()

#Parallel Coordinates Plot
options(viewer=NULL)
#remove nans
erTabNoNAN=erTab[which(!is.nan(erTab$value)),]
errorTable.PPC=codeAllVariables(erTabNoNAN)
p <- errorTable.PPC%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = 0,
                      cmax = 0.3),
          dimensions = list(
            list(range = c(0,250),
                 label = 'No.Objects Per Class', values = ~nrTrObjectsPerClass),
            list(range = c(0,3),
                 label = 'Representation', values = ~Representation,tickvals = c(1,2,3),ticktext = c("Pixels","Features","Dissimilarity")),
            list(range = c(0,5),
                 label = 'Resize Method', values = ~resizeMethod,tickvals = c(1,2,3,4),ticktext = c("bicubic","bilinear","nearest","box")),
            list(range = c(0,18),
                 label = 'Resize Size', values = ~resizeSize),
            list(range = c(0,1),
                 label = 'Thresholding', values = ~jitter(thresholding),tickvals = c(0,1),ticktext =c("False","True")),
            list(range = c(0,100),
                 label = 'No.Features', values = ~nrFeatures),
            list(range = c(0,1),
                 label = 'PCA', values = ~pca),
            list(range = c(1,8),
                 label = 'Classifiers', values = ~Classifier,tickvals = c(1,2,3,4,5,6,7),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc","treec")),
            list(range=c(0,0.3),  constraintrange = c(0,0.05), label='Classification Error',values=~ClassError)
          )
  )