## CORE LOGIC ##

# Addition
addition_problem <- function(range1, range2) {
  operand1 <- sample(range1,1)
  operand2 <- sample(range2,1)
  paste(operand1, "+", operand2, "=")
}

# Subtraction
subtraction_problem <- function(range1, range2, allow_negatives = F) {
  operand1 <- sample(range1,1)
  operand2 <- sample(range2,1)
  
  if (all(!allow_negatives, operand2 > operand1)) {
    while (operand2 > operand1) {
      operand2 <- sample(range2,1)
    }
  }
  
  paste(operand1, "-", operand2, "=")
}

## SHINY APP ##

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Math Races"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("operation",
                        label = "Operation:",
                        choices = list("Addition",
                                       "Subtraction")),
            sliderInput("range1start",
                        label = "Min Value for Operand 1",
                        min = 0,
                        max = 10,
                        value = 1),
            sliderInput("range1end",
                        label = "Max Value for Operand 1",
                        min = 0,
                        max = 10,
                        value = 5),
            sliderInput("range2start",
                        label = "Min Value for Operand 2",
                        min = 0,
                        max = 10,
                        value = 1),
            sliderInput("range2end",
                        label = "Max Value for Operand 2",
                        min = 0,
                        max = 10,
                        value = 5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           htmlOutput("problem_list")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$problem_list <- renderUI({
       
      if (input$operation == "Addition") {
      problems <- replicate(20, addition_problem(range1 = input$range1start:input$range1end, range2 = input$range2start:input$range2end))
      } else if (input$operation == "Subtraction") {
      problems <- replicate(20, subtraction_problem(range1 = input$range1start:input$range1end, range2 = input$range2start:input$range2end))
      }
      HTML(paste(problems, collapse = "<br>", sep = ""))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
