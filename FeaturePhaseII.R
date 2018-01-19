#Feature Representation Phase II
setwd("../../Documents/CS_DST/PR/Assignment/PR/experimentsFeaturePhase2/")
source("../Rplots.R")

#retrieve all files
files=list.files()

#produce errorTables and merge all into one
erTab=data.frame()
for (file in files){
  tempErTab=processFile(file)
  erTab=rbind(erTab,tempErTab)
}

write.csv(erTab,"SummaryTableFeaturesPhaseII.csv")

#Parallel Coordinates Plot Phase II
options(viewer=NULL)
#remove nans
erTabNoNAN=erTab[which(!is.nan(erTab$value)),]
errorTable.PPC=codeAllVariables(erTabNoNAN)
errorTable.PPC=codeOrdinal(errorTable.PPC,"nrFeatures",c(0,5,20,50,75,100),c(0.6,0.1,0.2,0.3,0.4,0.5))
errorTable.PPC$nrFeatures=as.character(errorTable.PPC$nrFeatures)

errorTable.PPC.Ph2Sc1=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==200),]
p <- errorTable.PPC.Ph2Sc1%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph2Sc1$ClassError),
                      cmax = 0.05),
          dimensions = list(
              list(range = c(0,0.7),
                 label = 'No.Features', values = ~jitter(as.numeric(nrFeatures)),tickvals = c(0.1,0.2,0.3,0.4,0.5,0.6),ticktext=as.character(c("5","20","50","75","100","All"))),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.7,0.8,0.85,0.90,0.95),ticktext = as.character(c("No PCA","0.70","0.80","0.85","0.90","0.95"))),
            list(range = c(1,8),
                 label = 'Classifier', values = ~jitter(Classifier),tickvals = c(1,2,3,4,5,6,7,8),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc","treec","fisherc")),
            list(range=c(0,1),  constraintrange = c(0,0.05),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))


errorTable.PPC.Ph2Sc2=errorTable.PPC[which(errorTable.PPC$nrTrObjectsPerClass==10),]
p <- errorTable.PPC.Ph2Sc2%>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ClassError,colorscale = 'Jet',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(errorTable.PPC.Ph2Sc1$ClassError),
                      cmax = 0.25),
          dimensions = list(
            list(range = c(0,0.7),
                 label = 'No.Features', values = ~jitter(as.numeric(nrFeatures)),tickvals = c(0.1,0.2,0.3,0.4,0.5,0.6),ticktext=as.character(c("5","20","50","75","100","All"))),
            list(range = c(0,1),
                 label = 'PCA', values = ~jitter(pca),tickvals = c(0,0.7,0.8,0.85,0.90,0.95),ticktext = as.character(c("No PCA","0.70","0.80","0.85","0.90","0.95"))),
            list(range = c(1,8),
                 label = 'Classifier', values = ~jitter(Classifier),tickvals = c(1,2,3,4,5,6,7,8),ticktext = c("svc","qdc","parzen","bpxnc","knnc","loglc","treec","fisherc")),
            list(range=c(0,1),  constraintrange = c(0,0.25),label='Classification Error',values=~ClassError)
          ))%>%   layout(font=list(size=17))