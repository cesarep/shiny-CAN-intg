library(shiny)
library(shinyjs)
library(xtable)


shinyServer(function(input, output, session) {
   #define tabela como um valor reativo
   rv <- reactiveValues(tabela=0, val=0, fx = function(x) 2*exp(-x^2)-1 )
   fTest = function(x) {}
   
   observeEvent(input$fx, {
      try({
         body(fTest) <- parse(text = paste0(input$fx))
         if( !is.primitive(fTest(1)) )
            body(rv$fx) <- body(fTest)
      }, silent = T)
   })

   observeEvent(input$metodo, {
      N = input$N
      if(input$metodo == 1)
         updateNumericInput(session, 'N', min = 1, step = 1)
      if(input$metodo == 2){
         if(N %% 2 == 0 && N >= 2)
            updateNumericInput(session, 'N', value = N, min = 2, step = 2)
         else
            updateNumericInput(session, 'N', value = N+1, min = 2, step = 2)
      }
   })
   
   observeEvent({rv$fx; input$metodo; input$a; input$b; input$N},{
      fx = rv$fx
      #faz calculos e tabela
      a = input$a
      b = input$b
      N = input$N
      h = (b-a)/N
      tabela <- NULL #define variavel tabela local
      val <- NULL
      if(input$metodo == 1)
         source('trap.R', local = T, encoding = 'UTF-8')
      if(input$metodo == 2)
         source('simp.R', local = T, encoding = 'UTF-8')
      rv$tabela <- tabela #atribui tabela local à reativa
      rv$val <- val
   })
   
   observeEvent(rv$tabela, {
      tabela = rv$tabela
      if(nrow(tabela)>10)
         modTab = list(pos=list(0, nrow(tabela)), 
                       command=c("<tr><th>\\(x\\)</th><th>\\(f(x)\\)</th></tr>", 
                                 paste0("<tr id='tabexp'><td align='center' colspan='", ncol(tabela),"'></td></tr>")
                       )
         )
      else
         modTab = list(pos=list(0), command="<tr><th>\\(x\\)</th><th>\\(f(x)\\)</th></tr>")
      output$tabela <- renderTable({
         tabela
      }, align='c', digits = 4, striped = T, include.colnames=FALSE, add.to.row = modTab)
      
      output$resultado <- renderUI({
         sprintf('$$ \\int_{%.2f}^{%.2f} \\! f(x) \\, \\mathrm{d}x \\approx %.3f $$', input$a, input$b, rv$val)})
   })
   
   
   output$plot <- renderPlot({
      a = input$a
      b = input$b
      N = input$N
      h = (b-a)/N
      fx = rv$fx
      tabela = rv$tabela
      plot.new(); plot.window(c(a,b)+0.5*c(-h, h), range(c(0, fx((750*a):(750*b)/750)))+0.5*c(-h, h))
      box(); axis(1); axis(2)
      abline(h=0, lty=2, col='grey')
      if(input$metodo == 1){
         for(i in 1:N){
            pX = c(tabela[i, 1], tabela[i, 1], tabela[i+1, 1], tabela[i+1, 1])
            pY = c(0, tabela[i, 2], tabela[i+1, 2], 0)
            polygon(pX, pY, col = "lightblue")
         }
      }
      if(input$metodo == 2){
         for(i in 1:(N/2)){
            j=2*i
            pX = c(tabela[j-1, 1], tabela[j, 1], tabela[j+1, 1])
            pY = c(tabela[j-1, 2], tabela[j, 2], tabela[j+1, 2])
            A = matrix(c(        3,   sum(pX), sum(pX^2), 
                           sum(pX), sum(pX^2), sum(pX^3),
                         sum(pX^2), sum(pX^3), sum(pX^4)),
                       3, 3, byrow = T)
            B = c(sum(pY), sum(pY*pX), sum(pY*(pX^2)))
            C = solve(A, B)
            p2 = function(x) C[1] + C[2]*x + C[3]*x^2
            ptos = curve(p2, pX[1], pX[3], add=T)
            polygon(c(pX[1], ptos$x, pX[3]), c(0, ptos$y, 0), col='lightblue')
            lines(rep(tabela[j, 1], 2), c(0, tabela[j, 2]), lty=2)
         }
      }
      curve(fx, input$a-h, input$b+h, add = T, lwd=2)
   })
  
})
