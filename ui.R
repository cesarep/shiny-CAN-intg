library(shiny)
library(shinyjs)

source('katex.r', encoding = 'utf-8')

shinyUI(fluidPage(
   KaTeX(),
   titlePanel("Integração Numérica"),
   sidebarLayout(
      sidebarPanel(
         textInput('fx', '\\(f(x)\\)', '2*exp(-x^2)-1'),
         includeCSS("www/estilo.css"),
         includeHTML('www/ajuda.htm'),
         includeScript('www/tabela.js'),
         includeCSS('www/tabela.css'),
         useShinyjs(),
         selectInput('metodo', 'Método', 
            list('Trapézio' = 1,
               'Simpson' = 2
            )
         ),
         splitLayout(
            numericInput('a', '\\(a\\)', 0, step = 0.5),
            numericInput('b', '\\(b\\)', 1, step = 0.5),
            numericInput('N', 'N', 5, 1, step = 1)
         )
      ),
      mainPanel(
         tabsetPanel(
            tabPanel("Resultados",
                     uiOutput('tabela'),
                     uiOutput('resultado'),
                     tags$style(type='text/css', "#tabela table {margin: 10px auto;}")
            ),
            tabPanel("Gráfico", 
               plotOutput('plot')
            )
         )
      )
   ),
   hr(),
   flowLayout(id = "cabecario",
              p(strong("Apoio:"), br(), img(src="NEPESTEEM.png")),
              p(strong("Agradecimento:"), br(), img(src="FAPESC.png")),
              p(strong("Desenvolvido por:"), br(), "César Eduardo Petersen")
              )
))
