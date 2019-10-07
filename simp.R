X = a
FX = fx(a)
for(i in 1:N){
   X[i+1] = X[i] + h
   FX[i+1] = fx(X[i+1])
}
tabela <- cbind(X, FX)

val <- 0
for(i in 1:(N+1)){
   if(i %% 2 == 0){
      val <- val + 4*FX[i]
   } else if((i %% 2 == 1) && (i != 1) && (i != (2*N+1))){
     val <- val + 2*FX[i]
   } else {
      val <- val + 1*FX[i]
   }
}
val <- val*h/3