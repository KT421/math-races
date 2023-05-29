server <- function(input, output) {
  
  operation <- shiny::eventReactive(input$generate, {
    input$operation
  })
  
  range1 <- shiny::eventReactive(input$generate, {
    input$range1[1]:input$range1[2]
  })
  
  range2 <- shiny::eventReactive(input$generate, {
    input$range2[1]:input$range2[2]
  })
  
  allow_negatives <- shiny::eventReactive(input$generate, {
    input$allow_negatives
  })
  
  div_remainders <- shiny::eventReactive(input$generate, {
    input$div_remainders
  })
  
  problem_list <- shiny::reactive({
    
    problems <- replicate(20, 
                          generate_problem(range1 = range1(), 
                                           range2 = range2(),
                                           operations = sample(operation(),1),
                                           allow_negatives = allow_negatives(),
                                           div_remainders = div_remainders()))
    
  })
  
  output$problem_list <- shiny::renderUI({
    
    shiny::HTML(paste(problem_list(), collapse = "<br>", sep = ""))
  })
  
  output$download <- shiny::downloadHandler(
    filename = "worksheet.html",
    content = function(file) {
      params <- list(n = problem_list())
      rmarkdown::render(system.file("Worksheet.Rmd", package = "mathraces"), 
                        output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()))
    }
    
  )
}
