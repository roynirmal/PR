#setwd("../../Documents/CS_DST/PR/Assignment/PR/DissRepScenario1/")

files=list.files()
AllFilesTab=data.frame()

for (file in files){
  tab=read.csv(file)
  size=str_extract(file,"Size.*(.)csv")
  size=gsub("(Size|(.)csv)","",size)
  training=str_extract(file,"Prototypes.*PixelSize")
  training=gsub("(Prototypes|PixelSize)","",training)
  summaryTab=meltDissScen1(tab,training,size)
  AllFilesTab=rbind(AllFilesTab,summaryTab)
}

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