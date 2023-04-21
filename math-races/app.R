## CORE LOGIC ##

# Addition

addition_problem <- function(range1 = 1:5, range2 = 1:5) {
  operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
  operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
  paste(operand1, "+", operand2, "=")
}

# Subtraction
subtraction_problem <- function(range1 = 1:5, range2 = 1:5, allow_negatives = F) {
  operand1 <- ifelse(length(range1) == 1, range1, sample(range1,1))
  operand2 <- ifelse(length(range2) == 1, range2, sample(range2,1))
  
  if (all(!allow_negatives, operand2 > operand1)) {
    while (operand2 > operand1) {
      operand2 <- sample(range2,1)
    }
  }
  
  paste(operand1, "-", operand2, "=")
}

## SHINY APP ##

library(shiny)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Math Races"),

    # Sidebar with inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput("operation",
                        label = "Operation:",
                        choices = list("Addition",
                                       "Subtraction")),
            sliderInput("range1",
                        label = "Value Range for Operand 1",
                        min = 0,
                        max = 10,
                        value = c(1,5)),
            sliderInput("range2",
                        label = "Value Range for Operand 2",
                        min = 0,
                        max = 10,
                        value = c(1,5)),
            actionButton("generate", "Generate Problems")
        ),

        # Outputs
        mainPanel(
           htmlOutput("problem_list"),
           downloadButton("download", "Download Printable")
        )
    )
)

# Define server logic 
server <- function(input, output) {

  range1 <- eventReactive(input$generate, {
    input$range1[1]:input$range1[2]
  })
  
  range2 <- eventReactive(input$generate, {
    input$range2[1]:input$range2[2]
  })
  
  problem_list <- reactive({
    
    if (input$operation == "Addition") {
      problems <- replicate(20, addition_problem(range1 = range1(), range2 = range2()))
    } else if (input$operation == "Subtraction") {
      problems <- replicate(20, subtraction_problem(range1 = range1(), range2 = range2()))
    }
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
