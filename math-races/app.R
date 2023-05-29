## CORE LOGIC ##

# named list for replacement
operation_lookup <- c("Addition" = "+",
                      "Subtraction" = "-",
                      "Multiplication" = "*", 
                      "Division" = "÷")

# make problem
generate_problem <- function(range1,range2,operations,allow_negatives = F, div_remainders = F) {
  
  operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
  operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
  operation <- ifelse(length(operations) == 1, operations, sample(operations,1))
  
  # rerolls for subtraction - negative answers
  if (all(!allow_negatives, operand2 > operand1, operation == "Subtraction")) {
    while (operand2 > operand1) {
      operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
      operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
    }
  }
  
  # rerolls for division
  # no divide by zero plz
  if (all(operation == "Division", operand2 == 0)) {
    operand2 <- 1
  }
  # reroll if we don't want remainders
  if (all(!div_remainders, operand1 %% operand2 != 0, operation == "Division")) {
    while (operand1 %% operand2 != 0) {
      operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
      operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
        # no divide by zero in the reroll plskthx -- yes this is stupid. I will come up with a better way.
      if (operand2 == 0) operand2 <- 1
    }
  }
  
  paste(operand1, operation_lookup[operation], operand2, "=")
  
}
## SHINY APP ##

library(shiny)
library(tidyverse)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Math Races"),

    # Sidebar with inputs 
    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("operation",
                        label = "Operation:",
                        choices = list("Addition",
                                       "Subtraction",
                                       "Multiplication",
                                       "Division"),
                        selected = "Addition"),
            sliderInput("range1",
                        label = "Value Range for Operand 1",
                        min = 0,
                        max = 100,
                        value = c(1,5)),
            sliderInput("range2",
                        label = "Value Range for Operand 2",
                        min = 0,
                        max = 100,
                        value = c(1,5)),
            checkboxInput("allow_negatives", 
                          label = "Allow negative answers in subtraction problems?", 
                          value = FALSE),
            checkboxInput("div_remainders", 
                        label = "Allow division problems with remainders?", 
                        value = FALSE),
            actionButton("generate", "Generate Problems"),
            downloadButton("download", "Download Printable")
        ),

        # Outputs
        mainPanel(
           htmlOutput("problem_list")
        )
    )
)

# Define server logic 
server <- function(input, output) {

  operation <- eventReactive(input$generate, {
      input$operation
  })
  
  range1 <- eventReactive(input$generate, {
    input$range1[1]:input$range1[2]
  })
  
  range2 <- eventReactive(input$generate, {
    input$range2[1]:input$range2[2]
  })
  
  allow_negatives <- eventReactive(input$generate, {
    input$allow_negatives
  })
  
  div_remainders <- eventReactive(input$generate, {
    input$div_remainders
  })
  
  problem_list <- reactive({
  
      problems <- replicate(20, 
                            generate_problem(range1 = range1(), 
                                              range2 = range2(),
                                              operations = sample(operation(),1),
                                              allow_negatives = allow_negatives(),
                                              div_remainders = div_remainders()))

  })
  
  output$problem_list <- renderUI({
      
      HTML(paste(problem_list(), collapse = "<br>", sep = ""))
    })
  
  output$download <- downloadHandler(
    filename = "worksheet.html",
    content = function(file) {
      params <- list(n = problem_list())
      rmarkdown::render("worksheet.Rmd", 
                        output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()))
                        }
    
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
