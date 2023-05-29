ui <- shiny::fluidPage(
  
  # Application title
  shiny::titlePanel("Math Races"),
  
  # Sidebar with inputs 
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::checkboxGroupInput("operation",
                         label = "Operation:",
                         choices = list("Addition",
                                        "Subtraction",
                                        "Multiplication",
                                        "Division"),
                         selected = "Addition"),
      shiny::sliderInput("range1",
                  label = "Value Range for Operand 1",
                  min = 0,
                  max = 100,
                  value = c(1,5)),
      shiny::sliderInput("range2",
                  label = "Value Range for Operand 2",
                  min = 0,
                  max = 100,
                  value = c(1,5)),
      shiny::checkboxInput("allow_negatives", 
                    label = "Allow negative answers in subtraction problems?", 
                    value = FALSE),
      shiny::checkboxInput("div_remainders", 
                    label = "Allow division problems with remainders?", 
                    value = FALSE),
      shiny::actionButton("generate", "Generate Problems"),
      shiny::downloadButton("download", "Download Printable")
    ),
    
    # Outputs
    shiny::mainPanel(
      shiny::tabsetPanel(
        shiny::tabPanel("Main",shiny::htmlOutput("problem_list")),
        shiny::tabPanel("Read me!",shiny::includeMarkdown(system.file("in_app_documentation.md", package = "mathraces")))
      )
    )
  )
)
