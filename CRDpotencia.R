alpha=c(0.01,.025,.05,.1)
v=2
r=seq(2,20,1)
DELTA=1
sigma3=.12
power=matrix(0,ncol=length(alpha),nrow=length(r))
for (i in 1:length(alpha)){
  delta2=matrix(0,ncol=1,nrow=length(r))
  for (j in 1:length(r)){
    delta2[j]=r[j]*DELTA^2/(2*sigma3)
    power[j,i]=1-pf(qf(1-alpha[i],df1=v-1,df2=v*(r[j]-1)),df1=v-1,df2=v*(r[j]-1),ncp=delta2[j])
  }
  
if (i==1){
  plot(delta2,power[,i],type='l',cex=.1, ylim=c(0,1),col=i, xlab=expression(delta^2), ylab='Potencia')
}  
  else{
    lines(delta2,power[,i],type='l',cex=.1, col=i)
  }

  
}
legend(15,.5,paste(alpha),lty=1,col=c(1:length(alpha)), title='Alpha')