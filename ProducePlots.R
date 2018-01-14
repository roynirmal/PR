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

errorTable.PPC=codeAllVariables(erTab)
p <- errorTable.PPC%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = 0,
                      cmax = 1),
          dimensions = list(
            list(range = c(0,250),
                 label = 'No.Objects Per Class', values = ~nrTrObjectsPerClass),
            list(range = c(0,3),
                 label = 'Representation', values = ~Representation),
            list(range = c(0,5),
                 label = 'Resize Method', values = ~resizeMethod),
            list(range = c(0,15),
                 label = 'Resize Size', values = ~resizeSize),
            list(range = c(0,1),
                 label = 'Thresholding', values = ~thresholding),
            list(range = c(0,100),
                 label = 'No.Features', values = ~nrFeatures),
            list(range = c(0,1),
                 label = 'PCA', values = ~pca),
            list(range = c(1,8),
                 label = 'Classifiers', values = ~Classifier),
            list(range=c(0,1),  constraintrange = c(0,0.25), label='Classification Error',values=~ClassError)
          )
  )